# Product API + UI (Express + MongoDB)

This project is a sample web application used as a reference platform for the Midterm Presentation of the course:

**502094 – Software Deployment, Operations and Maintenance**

The project demonstrates a simple product management system built with **Node.js, Express, and MongoDB**, including both a REST API and a server-side rendered web interface.

The repository is used as a deployment target for DevOps exercises covering:

- Git workflow and repository management
- Traditional server deployment
- Containerized deployment using Docker

Students are **not required to use this exact project**. Any equivalent or more complex system built using other languages or frameworks may also be used.

---

# System Overview

The application is structured following the **MVC architecture pattern (Model – View – Controller)** and provides a full CRUD interface for managing products.

Technologies used:

- **Node.js**
- **Express.js**
- **MongoDB (via Mongoose)**
- **EJS templates**
- **Bootstrap UI**

If the application fails to connect to MongoDB during startup (timeout **3 seconds**), it automatically switches to an **in-memory datastore** and continues running.

Each API response indicates:

- the **hostname** of the server
- the **data source** currently used (`mongodb` or `in-memory`)

---

# Key Features

### Product Management API

Full REST API for product management:

- Create product
- Read products
- Update product
- Delete product

Supported methods:


GET
POST
PUT
PATCH
DELETE


---

### Web Management Interface

A server-rendered UI is available at:


http://localhost:3000/


The interface allows users to:

- view product list
- add products
- edit products
- delete products

The UI is implemented using **EJS templates** and **Bootstrap**.

---

### Image Upload Support

Products can include images.

Uploaded images are stored locally in:


public/uploads/


The database stores the relative path:


/uploads/<filename>


When a product is updated or deleted:

- the previous image file is automatically removed from disk.

---

### Automatic Data Seeding

When the application starts and successfully connects to MongoDB:

- if the `products` collection is empty
- the application automatically **seeds 10 Apple sample products**

This helps demonstrate the application functionality immediately.

---

# Project Structure


main.js
models/
services/
controllers/
routes/
views/
public/


### main.js
Application entry point.

Responsibilities:

- connect to MongoDB
- apply connection timeout (3 seconds)
- enable fallback to in-memory datastore
- start the Express server

---

### models/

Contains database models.

Example:


models/product.js


Defines the Mongoose schema for products:

- name
- price
- color
- description
- imageUrl

---

### services/

Contains the **data source abstraction layer**.


services/dataSource.js


Responsibilities:

- abstract MongoDB vs in-memory storage
- implement CRUD operations
- seed sample products
- delete image files when products are updated or removed

---

### controllers/

Handles request processing and business logic.

Controllers receive requests from routes and interact with the data source.

---

### routes/

Defines application routes.


/products → REST API
/ → UI interface


---

### views/

Contains **EJS templates** used for server-side rendering.

Used by the UI to display and manage products.

---

### public/

Contains static assets:


public/
css/
js/
uploads/


The `uploads/` directory stores uploaded product images.

---

# Environment Configuration

The application uses a `.env` file.

Example configuration:


PORT=3000
MONGO_URI=mongodb://localhost:27017/products_db


If authentication is required for MongoDB, the connection string should include credentials.

---

# Installation

Install dependencies:


npm install


---

# Running the Application

Production mode:


npm start


Development mode (with nodemon):


npm run dev


Then open:


http://localhost:3000


---

# API Endpoints

### Get all products


GET /products


---

### Get product by id


GET /products/:id


---

### Create product

Supports multipart upload.


POST /products


Form fields:


name
price
color
description
imageFile


Example using curl:


curl -X POST
-F "name=My Device"
-F "price=199"
-F "color=black"
-F "description=Note"
-F "imageFile=@/path/to/photo.jpg"
http://localhost:3000/products


---

### Update product


PUT /products/:id
PATCH /products/:id


Both endpoints support multipart image upload.

---

### Delete product


DELETE /products/:id


Deletes both the product and its image file if present.

---

# Important Runtime Behavior

### MongoDB Connection Timeout

During startup, the application attempts to connect to MongoDB using:


serverSelectionTimeoutMS: 3000


If the connection fails:

- the application switches to **in-memory datastore**
- the server continues running

This ensures the system remains available even without database connectivity.

---

### Image Storage

Uploaded images are stored locally at:


public/uploads/


The database stores relative URLs, allowing images to be served directly by Express.

---

# Limitations

The current implementation stores images **locally on disk**.

This approach is suitable for:

- development
- demonstrations
- small-scale deployments

However, for production environments it is recommended to use cloud storage services such as:

- AWS S3
- Cloudinary

and store only the image URL in the database.

---

# Potential Improvements

Possible enhancements include:

- image size limits
- MIME type validation
- pagination for product lists
- cloud storage integration
- authentication and authorization

---

# Development Utilities

Install nodemon globally if desired:


npm install -g nodemon


Monitor application logs to determine whether the application is using:


mongodb
or
in-memory datastore


---

# Course Context

This project serves as the base application for deployment exercises in the course:

**Software Deployment, Operations and Maintenance**

The repository demonstrates:

- Git workflow practices
- server deployment
- containerized deployment using Docker
- reverse proxy configuration
- runtime reliability verification