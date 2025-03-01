const mongoose = require("mongoose")
mongoose.set("strictQuery", true)
async function connectMongo(url) {
      return await mongoose.connect(url);
}

module.exports = {
      connectMongo
}