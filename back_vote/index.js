const express = require('express');
const app = express();
const path = require('path');
const bodyParser = require('body-parser')
const fs = require("fs");
const { connectMongo } = require("./connection")
//const { getSignedUrl } = require("@aws-sdk/s3-request-presigner")
const { S3Client, PutObjectCommand, ListObjectsCommand, DeleteObjectCommand } = require("@aws-sdk/client-s3")
const { getSignedUrl } = require("@aws-sdk/cloudfront-signer")
const multer = require("multer")
const dotenv = require("dotenv")

app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

connectMongo("mongodb+srv://mannansyed660:xPgGBGSOPsPt6vqg@election-commision-db.1jfafy0.mongodb.net/?retryWrites=true&w=majority&appName=election-commision-db").then(() => {
      console.log("MongoDb Connected")
})

const User = require("./model/user")

dotenv.config()
const bucketName = process.env.AWS_BUCKET_NAME
const region = process.env.AWS_BUCKET_REGION
const accessKeyId = process.env.AWS_ACCESS_KEY
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY

//console.log(bucketName, region, accessKeyId, secretAccessKey)

const s3Client = new S3Client({
      region,
      credentials: {
            accessKeyId,
            secretAccessKey
      }
})

app.set('view engine', 'ejs');
app.use(express.static('public'))
app.use('/my-uploads', express.static(path.resolve(__dirname, 'my-uploads')));

// async function putobjectUrl(ext) {
//       const file = Date.now()
//       const command = new PutObjectCommand({
//             Bucket: bucketName,
//             Key: `uploads/${Date.now()}.${ext}`,
//             ContentType: `image/${ext}`
//       });
//       const url = await getSignedUrl(s3Client, command);
//       return url;
// }


// async function listobject() {

// }

// async function init() {
//       await listobject()
// }


// const storage = multer.diskStorage({
//       destination: function (req, file, cb) {
//             var dir = './my-uploads'
//             if (!fs.existsSync(dir)) {
//                   fs.mkdirSync(dir);
//             }

//             cb(null, dir)
//       },
//       filename: function (req, file, cb) {
//             cb(null, file.fieldname + '-' + Date.now() + '.jpeg')
//       }
// })

// const upload = multer({ storage: storage }).array('files', 12)

// app.post('/photos/upload', function (req, res, next) {
//       // req.files is array of `photos` files
//       // req.body will contain the text fields, if there were any
//       upload(req, res, function (err) {
//             if (err) {
//                   return res.send("Something goes Wrong");
//             }
//             res.send("Upload Completed")
//       })
// })

// app.get('/electioncomission/service', async (req, res) => {
// const folderPath = path.join(__dirname, 'my-uploads');

// fs.readdir(folderPath, (err, files) => {
//       if (err) {
//             console.error('Error reading folder:', err);
//             res.status(500).send('Internal Server Error');
//             return;
//       }

//       const imageFileNames = files.filter(file => file.endsWith('.jpeg')); // Adjust the file extension as needed
//       const imageFileNames1 = files[1];
//       res.render('service', { imageFileNames, imageFileNames1 });
// });
//       var file = [];
//       const command = new ListObjectsCommand({
//             Bucket: bucketName,
//             Key: '/uploads'
//       });
//       const result = await s3Client.send(command);
//       result['Contents'].forEach((filename, index) => {
//             // console.log(filename['Key']);
//             file.push(filename['Key'])

//       })
//       var url = [];
//       for (var i = 0; i < file.length; i++) {

//             console.log(file[i])
//             const signedUrl = getSignedUrl({
//                   keyPairId: process.env.CLOUDFRONT_KEYPAIR_ID,
//                   privateKey: process.env.CLOUDFRONT_PRIVATE_KEY,
//                   url: "https://d2iyhx4kywrlz6.cloudfront.net/" + file[i],
//                   dateLessThan: new Date(Date.now() + (1000 * 60 * 60 * 24))
//             })
//console.log(signedUrl)
//             url.push(signedUrl)
//       }
//console.log(url)
//       res.render('service', { url });
// })

// app.post('/post', async (req, res) => {
//       console.log("hello")
//       var ext = req.body.ext
//       console.log(ext)
//       let v = await putobjectUrl(ext)
//       console.log(v)
//       res.send({ v: v })
// })

const routeUpload = require('./routes/Upload')
const routeCloudFront = require('./routes/CloudFront');
const { connect } = require('http2');
const routeData = require('./routes/data')
const Connection = require('./routes/Connection')
app.use(Connection)
app.use(routeCloudFront)
app.use(routeUpload)
app.use(routeData)

app.listen(5000, () => console.log(`Server Started in 5000 Port`));