const express = require('express');
const router = express.Router();
const controller = require('../../controllers/productController');
const validators = require('../../validators/productValidator');
const { validationResult } = require('express-validator');
const multer = require('multer');
// Use memory storage so req.file.buffer is available for S3 upload
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 } // 10MB
});

// Accept multiple common field names from clients
const uploadImage = upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'imageFile', maxCount: 1 },
  { name: 'file', maxCount: 1 }
]);

// Normalize uploaded file so controller can always read req.file.buffer
function normalizeUploadedFile(req, res, next) {
  const files = req.files || {};
  req.file =
    (files.image && files.image[0]) ||
    (files.imageFile && files.imageFile[0]) ||
    (files.file && files.file[0]) ||
    null;
  next();
}

function handleValidation(req, res, next) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  next();
}

router.get('/', controller.list);
router.get('/:id', controller.getOne);
router.post('/', uploadImage, normalizeUploadedFile, validators.create, handleValidation, controller.create);
router.put('/:id', uploadImage, normalizeUploadedFile, validators.put, handleValidation, controller.put);
router.patch('/:id', uploadImage, normalizeUploadedFile, validators.patch, handleValidation, controller.patch);
router.delete('/:id', controller.remove);

module.exports = router;
