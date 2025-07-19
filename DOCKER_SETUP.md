# 🐳 Docker Setup Guide - Rakshak Expense Management System

This guide will help you run the Rakshak Expense Management System using Docker and Docker Compose.

## 📋 Prerequisites

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 2.0 or higher)
- **Git** (to clone the repository)

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd Expenses-software-
```

### 2. Build and Run with Docker Compose
```bash
# Build and start all services
docker-compose up --build

# Or run in detached mode
docker-compose up --build -d
```

### 3. Access the Application
- **Frontend**: http://localhost:5001
- **Backend API**: http://localhost:5001/api
- **Health Check**: http://localhost:5001/api/health
- **MongoDB**: localhost:27017

## 🔧 Configuration

### Environment Variables

The application uses the following environment variables (configured in `docker-compose.yml`):

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | production |
| `PORT` | Backend server port | 5001 |
| `MONGODB_URI` | MongoDB connection string | mongodb://admin:password123@mongodb:27017/rakshak-expense?authSource=admin |
| `JWT_SECRET` | JWT signing secret | your-super-secret-jwt-key-change-in-production |
| `JWT_EXPIRES_IN` | JWT expiration time | 24h |
| `BCRYPT_ROUNDS` | Password hashing rounds | 12 |
| `FRONTEND_URL` | Frontend URL for CORS | http://localhost:3000 |

### Custom Environment File

Create a `.env` file in the root directory to override defaults:

```env
NODE_ENV=production
PORT=5001
MONGODB_URI=mongodb://admin:your-password@mongodb:27017/rakshak-expense?authSource=admin
JWT_SECRET=your-very-secure-jwt-secret-key
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12
FRONTEND_URL=http://localhost:5001
```

## 🏗️ Architecture

The Docker setup includes:

### Services
1. **app** - Main application (Node.js + React)
2. **mongodb** - MongoDB database
3. **nginx** - Reverse proxy (optional, for production)

### Volumes
- `mongodb_data` - MongoDB data persistence
- `app_logs` - Application logs
- `uploads` - File uploads

### Networks
- `rakshak-network` - Internal communication

## 📊 Default Credentials

After the first run, the system creates:

- **Admin User**: 
  - Email: `admin@rakshak.com`
  - Password: `admin123`
- **Default Site**: Head Office (Mumbai, Maharashtra)

## 🛠️ Development Commands

### Start Services
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Start specific service
docker-compose up mongodb
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Stop and remove images
docker-compose down --rmi all
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs app
docker-compose logs mongodb

# Follow logs
docker-compose logs -f app
```

### Access Containers
```bash
# Access app container
docker-compose exec app sh

# Access MongoDB
docker-compose exec mongodb mongosh

# Access MongoDB with authentication
docker-compose exec mongodb mongosh -u admin -p password123
```

## 🔍 Monitoring and Health Checks

### Health Check Endpoints
- **Application**: http://localhost:5001/api/health
- **MongoDB**: Built-in health check in docker-compose

### Container Status
```bash
# Check container status
docker-compose ps

# Check resource usage
docker stats
```

## 🚀 Production Deployment

### 1. Production with Nginx
```bash
# Start with nginx reverse proxy
docker-compose --profile production up -d
```

### 2. SSL/HTTPS Setup
1. Place SSL certificates in `./ssl/` directory
2. Update `nginx.conf` with your domain
3. Uncomment HTTPS server block in nginx.conf

### 3. Environment Variables for Production
```env
NODE_ENV=production
JWT_SECRET=your-production-secret-key
MONGODB_URI=mongodb://admin:strong-password@mongodb:27017/rakshak-expense?authSource=admin
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Check what's using the port
netstat -tulpn | grep :5001

# Kill the process
sudo kill -9 <PID>
```

#### 2. MongoDB Connection Issues
```bash
# Check MongoDB logs
docker-compose logs mongodb

# Restart MongoDB
docker-compose restart mongodb
```

#### 3. Build Failures
```bash
# Clean build
docker-compose down
docker system prune -f
docker-compose up --build
```

#### 4. Permission Issues
```bash
# Fix file permissions
sudo chown -R $USER:$USER .
```

### Debug Commands
```bash
# Check container logs
docker-compose logs app

# Access container shell
docker-compose exec app sh

# Check network connectivity
docker-compose exec app ping mongodb

# Check MongoDB connection
docker-compose exec app node -e "
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));
"
```

## 📝 Database Management

### Backup Database
```bash
# Create backup
docker-compose exec mongodb mongodump --out /data/backup --db rakshak-expense

# Copy backup to host
docker cp rakshak-mongodb:/data/backup ./backup
```

### Restore Database
```bash
# Copy backup to container
docker cp ./backup rakshak-mongodb:/data/

# Restore database
docker-compose exec mongodb mongorestore --db rakshak-expense /data/backup/rakshak-expense
```

## 🔒 Security Considerations

### Production Security Checklist
- [ ] Change default JWT secret
- [ ] Use strong MongoDB password
- [ ] Enable HTTPS with SSL certificates
- [ ] Configure firewall rules
- [ ] Set up proper logging
- [ ] Regular security updates
- [ ] Database backups

### Security Headers
The nginx configuration includes security headers:
- X-Frame-Options
- X-XSS-Protection
- X-Content-Type-Options
- Content-Security-Policy

## 📈 Performance Optimization

### Resource Limits
Add to `docker-compose.yml`:
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
```

### Caching
- Static assets are cached for 1 year
- API responses can be cached with appropriate headers

## 🎯 Next Steps

1. **Customize Configuration**: Update environment variables
2. **Add SSL**: Configure HTTPS for production
3. **Set up Monitoring**: Add monitoring tools
4. **Configure Backups**: Set up automated database backups
5. **Load Balancing**: Add multiple app instances for high availability

## 📞 Support

For issues and questions:
- Check the troubleshooting section
- Review container logs
- Contact the development team

---

**Happy Dockerizing! 🐳** 