const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
      Fname:{
            type: String,
            required:[true,"Please add your First Name"]
            },
      Lname:{
            type:String,
            required:[true,"Please add your Last Name"]
      } ,
      Email:{
            type:String,
            require:true,
            unique: true,
            // validator: [validator.isEmail, 'invalid email']
      }     ,
      Phone:{
            type:Number,
            require:true,
            unique: true,
      },
      AddharNumber:{
            type:String,
            require:true,
            unique: true,
      },
      fcm_token:{
            type:String
      },
      Verify:{
            type:Boolean,
            default:false
      }
})

module.exports = mongoose.model("User", userSchema);