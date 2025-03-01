const path = require('path');
const express = require('express');
const router = express.Router();
const dotenv = require("dotenv")
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner")
const { S3Client, PutObjectCommand, ListObjectsCommand, DeleteObjectCommand } = require("@aws-sdk/client-s3")
const { CloudFrontClient, CreateInvalidationCommand } = require("@aws-sdk/client-cloudfront")
const User = require("../model/user")
const sendPushNotification = require("../pushNotification/pushnotification")

dotenv.config()
const bucketName = process.env.AWS_BUCKET_NAME
const region = process.env.AWS_BUCKET_REGION
const accessKeyId = process.env.AWS_ACCESS_KEY
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY

console.log(bucketName, region, accessKeyId, secretAccessKey)

const s3Client = new S3Client({
      region,
      credentials: {
            accessKeyId,
            secretAccessKey
      }
})

const cloudfrontDistributionId = process.env.CLOUDFRONT_DISTRIBUTION_ID

const cloudfront = new CloudFrontClient({
      region,
      credentials: {
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey,
      }
});

async function putobjectUrl(ext, AddharNumber) {
      const file = Date.now()
      const command = new PutObjectCommand({
            Bucket: bucketName,
            Key: `uploads/${AddharNumber}/${Date.now()}.${ext}`,
            ContentType: `image/${ext}`
      });
      const url = await getSignedUrl(s3Client, command);
      return url;
}

router.post("/post", async (req, res) => {
      console.log("hello")
      var ext = req.body.ext
      var AddharNumber = req.body.AddharNumber
      console.log(ext, AddharNumber)
      let v = await putobjectUrl(ext, AddharNumber)
      console.log(v)
      res.send({ v: v })
})

router.get("/delete/:DeleteUrl?", async (req, res) => {
      const DeleteUrl = req.query.DeleteUrl
      var arl = []
      arl.push(DeleteUrl.split(',')[0])
      arl.push(DeleteUrl.split(',')[1])
      arl.push(DeleteUrl.split(',')[2])
      var brl = DeleteUrl.split(',')[3]
      //arl.push(DeleteUrl.split(',')[3])
      //  JSON.parse();
      //console.log(brl)
      var Addhar = brl.split('S').pop()
      //console.log(Addhar)
      var last = brl.split('S')[0]
      //console.log(last)
      arl.push(last)
      var mesAd = brl.split('S')[1]
      const type = mesAd.split('S')[0]
      var users = await User.findOne({ AddharNumber: Addhar });

      //console.log(type)
      if (type == 'success') {
            var user = await User.findOneAndUpdate({ AddharNumber: Addhar }, { Verify: true }, { new: true })
            const fcm_token = users.fcm_token;
            console.log(`Device Token : ${fcm_token}`)
            const body = "Your Account is Being Verified Check your Account ";
            console.log("Notification jaye ga")
            sendPushNotification(fcm_token, type, body)
            console.log("Notification chala gya")
            console.log('User account verified:', user);
      } else {
            const deletedUser = await User.findOneAndDelete({ AddharNumber: Addhar });
            console.log('User deleted:', deletedUser);
      }

      async function checknum(i) {
            console.log("FileName in bucket:" + arl[i])
            var cmd = new DeleteObjectCommand({
                  Bucket: bucketName,
                  Key: `uploads/${Addhar}/${arl[i]}`
            })
            console.log("Process to delete the file")
            await s3Client.send(cmd);
            console.log("File is been deleted ")
            cachedelete(i)
            console.log("Fileis been deleted in cache also")
            // var cfCommand = new CreateInvalidationCommand({
            //       DistributionId: cloudfrontDistributionId,
            //       InvalidationBatch: {
            //             CallerReference: `uploads/${arl[i]}`,
            //             Paths: {
            //                   Quantity: 1,
            //                   Items: [
            //                         "/" + `uploads/${arl[i]}`
            //                   ]
            //             }
            //       }
            // })

            // var response = await cloudfront.send(cfCommand)
      }
      for (var i = 0; i < arl.length; i++) {
            checknum(i)

      }
      async function cachedelete(i) {
            var cfCommand = new CreateInvalidationCommand({
                  DistributionId: cloudfrontDistributionId,
                  InvalidationBatch: {
                        CallerReference: `uploads/${Addhar}/${arl[i]}`,
                        Paths: {
                              Quantity: 1,
                              Items: [
                                    "/" + `uploads/${Addhar}/${arl[i]}`
                              ]
                        }
                  }
            })

            var response = await cloudfront.send(cfCommand)
      }
      setTimeout(() => {
            res.redirect('electioncomission/service');
      }, 10000)


})

module.exports = router;