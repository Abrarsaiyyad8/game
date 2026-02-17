import express from "express";
import bodyParser from "body-parser";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand } from "@aws-sdk/lib-dynamodb";

const app = express();
app.use(bodyParser.json());

// AWS DynamoDB Client
const client = new DynamoDBClient({
  region: "ap-south-1",
});

app.post("/save-user", async (req, res) => {
  try {
    const { name, email, city } = req.body;

    if (!name || !email || !city) {
      return res.status(400).json({ message: "Missing fields" });
    }

    const params = {
      TableName: "game-scores",
      Item: {
        userId: Date.now().toString(),
        name,
        email,
        city,
      },
    };

    await client.send(new PutCommand(params));

    res.json({ message: "User saved successfully" });
  } catch (error) {
    console.error("ERROR:", error);
    res.status(500).json({
      message: "Internal Server Error",
      error: error.message,
    });
  }
});

app.get("/", (req, res) => {
  res.send("Game Backend Running 🚀");
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
