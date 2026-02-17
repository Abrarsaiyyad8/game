import express from "express";
import bodyParser from "body-parser";
import cors from "cors";   // ✅ ADD THIS
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand } from "@aws-sdk/lib-dynamodb";

const app = express();

/* ---------------- CORS FIX ---------------- */
// Allow requests from nginx frontend
app.use(cors({
  origin: "*",   // allow all (for now)
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type"]
}));

// Handle preflight requests (VERY IMPORTANT)
app.options("*", cors());

/* ------------------------------------------ */

app.use(bodyParser.json());

/* -------- AWS DynamoDB Client -------- */
const client = new DynamoDBClient({
  region: "ap-south-1",
});

/* -------- THIS ROUTE MUST MATCH FRONTEND -------- */
/* Your frontend calls POST /score */
app.post("/score", async (req, res) => {
  try {
    console.log("Incoming Data:", req.body);

    const { userId, name, email, city, score } = req.body;

    if (!userId || !name || !email || !city) {
      return res.status(400).json({ message: "Missing fields" });
    }

    const params = {
      TableName: "game-scores",
      Item: {
        userId: userId,        // ✅ using your DynamoDB PK
        name: name,
        email: email,
        city: city,
        score: score || 0,
        createdAt: new Date().toISOString(),
      },
    };

    await client.send(new PutCommand(params));

    console.log("Saved to DynamoDB");

    res.status(200).json({
      message: "User saved successfully"
    });

  } catch (error) {
    console.error("DynamoDB ERROR:", error);
    res.status(500).json({
      message: "Internal Server Error",
      error: error.message,
    });
  }
});

/* -------- Health Check -------- */
app.get("/", (req, res) => {
  res.send("Game Backend Running 🚀");
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
