import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand } from "@aws-sdk/lib-dynamodb";
import client from "prom-client";   // ✅ Prometheus client (ESM import)

/* ---------------- APP SETUP ---------------- */
const app = express();

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type"]
}));

app.options("*", cors());
app.use(bodyParser.json());

/* ---------------- AWS DYNAMODB ---------------- */
const dbClient = new DynamoDBClient({
  region: "ap-south-1",
});

/* ---------------- PROMETHEUS SETUP ---------------- */

// Create Registry
const register = new client.Registry();

// Collect default system metrics (CPU, Memory, etc.)
client.collectDefaultMetrics({ register });

// Custom Metrics
const gamesPlayed = new client.Counter({
  name: "game_sessions_total",
  help: "Total number of games played",
});

const scoreHistogram = new client.Histogram({
  name: "game_score_distribution",
  help: "Score distribution",
  buckets: [10, 50, 100, 200, 500],
});

const apiRequests = new client.Counter({
  name: "api_requests_total",
  help: "Total API Requests",
});

// Register Metrics
register.registerMetric(gamesPlayed);
register.registerMetric(scoreHistogram);
register.registerMetric(apiRequests);

/* ---------------- SCORE API ---------------- */
app.post("/score", async (req, res) => {
  try {
    apiRequests.inc();   // Count API hits
    gamesPlayed.inc();   // Count game session

    console.log("Incoming Data:", req.body);

    const { userId, name, email, city, score } = req.body;

    if (!userId || !name || !email || !city) {
      return res.status(400).json({ message: "Missing fields" });
    }

    // Track score in Prometheus
    if (score !== undefined) {
      scoreHistogram.observe(Number(score));
    }

    const params = {
      TableName: "game-scores",
      Item: {
        userId: userId,
        name: name,
        email: email,
        city: city,
        score: score ?? 0,
        createdAt: new Date().toISOString(),
      },
    };

    await dbClient.send(new PutCommand(params));

    console.log("Saved to DynamoDB");

    res.status(200).json({
      message: "User saved successfully",
    });

  } catch (error) {
    console.error("DynamoDB ERROR:", error);
    res.status(500).json({
      message: "Internal Server Error",
      error: error.message,
    });
  }
});

/* ---------------- METRICS ENDPOINT ---------------- */
// Prometheus will scrape this URL
app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

/* ---------------- HEALTH CHECK ---------------- */
app.get("/", (req, res) => {
  res.send("Game Backend Running 🚀");
});

/* ---------------- START SERVER ---------------- */
const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
