const os = require('os');
const dataSource = require('../services/dataSource');
const fs = require('fs');
const path = require('path');
const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');

const s3 = new S3Client({
  region: process.env.AWS_REGION
});

async function uploadToS3(file) {
  const key = `products/${Date.now()}-${file.originalname}`;
  await s3.send(new PutObjectCommand({
    Bucket: process.env.S3_BUCKET,
    Key: key,
    Body: file.buffer,
    ContentType: file.mimetype
  }));
  return key;
}

function s3PublicUrl(key) {
  // Basic public S3 URL (works if the object is publicly readable or served via bucket policy/CloudFront)
  return `https://${process.env.S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${key}`;
}

function saveLocal(file) {
  const uploadDir = path.join(__dirname, '..', 'public', 'uploads');
  if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
  }
  const filename = Date.now() + '-' + file.originalname;
  const fullPath = path.join(uploadDir, filename);
  fs.writeFileSync(fullPath, file.buffer);
  return `/uploads/${filename}`;
}

function meta() {
  return { hostname: os.hostname(), source: dataSource.isMongo ? 'mongodb' : 'in-memory' };
}

async function list(req, res, next) {
  try {
    const items = await dataSource.getAll();
    res.json({ data: items, ...meta() });
  } catch (err) { next(err); }
}

async function getOne(req, res, next) {
  try {
    const item = await dataSource.getById(req.params.id);
    if (!item) return res.status(404).json({ message: 'Not found', ...meta() });
    res.json({ data: item, ...meta() });
  } catch (err) { next(err); }
}

async function create(req, res, next) {
  try {
    const file = req.file;
    const payload = (({ name, price, color, description }) => ({ name, price, color, description }))(req.body);
    if (file) {
      if (process.env.S3_BUCKET && process.env.AWS_REGION) {
        const key = await uploadToS3(file);
        payload.imageUrl = s3PublicUrl(key);
      } else {
        payload.imageUrl = saveLocal(file);
      }
    }
    const item = await dataSource.create(payload);
    res.status(201).json({ data: item, ...meta() });
  } catch (err) { next(err); }
}

async function put(req, res, next) {
  try {
    const file = req.file;
    const payload = (({ name, price, color, description }) => ({ name, price, color, description }))(req.body);
    if (file) {
      if (process.env.S3_BUCKET && process.env.AWS_REGION) {
        const key = await uploadToS3(file);
        payload.imageUrl = s3PublicUrl(key);
      } else {
        payload.imageUrl = saveLocal(file);
      }
    }
    const item = await dataSource.replace(req.params.id, payload);
    if (!item) return res.status(404).json({ message: 'Not found', ...meta() });
    res.json({ data: item, ...meta() });
  } catch (err) { next(err); }
}

async function patch(req, res, next) {
  try {
    const file = req.file;
    const payload = {};
    ['name','price','color','description'].forEach(k => { if (k in req.body) payload[k] = req.body[k]; });
    if (file) {
      if (process.env.S3_BUCKET && process.env.AWS_REGION) {
        const key = await uploadToS3(file);
        payload.imageUrl = s3PublicUrl(key);
      } else {
        payload.imageUrl = saveLocal(file);
      }
    }
    const item = await dataSource.patch(req.params.id, payload);
    if (!item) return res.status(404).json({ message: 'Not found', ...meta() });
    res.json({ data: item, ...meta() });
  } catch (err) { next(err); }
}

async function remove(req, res, next) {
  try {
    const item = await dataSource.remove(req.params.id);
    if (!item) return res.status(404).json({ message: 'Not found', ...meta() });
    res.json({ data: item, ...meta() });
  } catch (err) { next(err); }
}

module.exports = { list, getOne, create, put, patch, remove };
