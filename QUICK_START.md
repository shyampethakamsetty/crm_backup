# 🚀 Quick Start Guide - Rakshak Expense Management System

## 🐳 Docker Setup (Recommended)

### Prerequisites
- Docker Desktop installed and running
- Git (to clone the repository)

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd Expenses-software-
```

### 2. Start with Docker (Easiest Method)
```bash
# Make the script executable (if not already)
chmod +x docker-scripts.sh

# Start the application
./docker-scripts.sh start
```

### 3. Access the Application
- **Main Application**: http://localhost:5001
- **API Health Check**: http://localhost:5001/api/health

### 4. Login Credentials
- **Email**: admin@rakshak.com
- **Password**: admin123

## 🛠️ Alternative Docker Commands

### Using Docker Compose Directly
```bash
# Start all services
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Using the Management Script
```bash
# Start application
./docker-scripts.sh start

# View logs
./docker-scripts.sh logs

# Check status
./docker-scripts.sh status

# Stop application
./docker-scripts.sh stop

# Restart application
./docker-scripts.sh restart

# Access container shell
./docker-scripts.sh shell

# Create database backup
./docker-scripts.sh backup

# Show help
./docker-scripts.sh help
```

## 🔧 Manual Setup (Without Docker)

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (local or Atlas)
- npm or yarn

### 1. Install Dependencies
```bash
# Install all dependencies
npm run install-all
```

### 2. Set up Environment
Create `.env` file in the backend directory:
```env
PORT=5001
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/rakshak-expense
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12
```

### 3. Start Development Servers
```bash
# Start both frontend and backend
npm run dev-single-port
```

### 4. Access the Application
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:5001

## 📊 What's Included

### Features
- ✅ Multi-level expense approval workflow
- ✅ Role-based access control
- ✅ Budget management
- ✅ Vehicle KM tracking
- ✅ Real-time notifications
- ✅ File upload support
- ✅ Comprehensive reporting

### User Roles
1. **Submitter** - Submit expenses
2. **L1 Approver** - Regional Manager approval
3. **L2 Approver** - Admin level approval
4. **L3 Approver** - Finance level approval
5. **Admin** - Full system access

## 🔍 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
netstat -tulpn | grep :5001

# Kill the process
sudo kill -9 <PID>
```

#### Docker Issues
```bash
# Check Docker status
docker info

# Restart Docker Desktop
# (Restart Docker Desktop application)
```

#### MongoDB Connection Issues
```bash
# Check MongoDB logs
docker-compose logs mongodb

# Restart MongoDB
docker-compose restart mongodb
```

### Get Help
```bash
# Show all available commands
./docker-scripts.sh help

# Check application status
./docker-scripts.sh status

# View detailed logs
./docker-scripts.sh logs
```

## 📚 Next Steps

1. **Explore the Application**: Login and explore the features
2. **Create Users**: Add new users with different roles
3. **Set up Sites**: Configure your business locations
4. **Customize**: Modify settings and configurations
5. **Deploy**: Set up for production use

## 📞 Support

- **Documentation**: See `DOCKER_SETUP.md` for detailed instructions
- **Issues**: Check the troubleshooting section
- **Logs**: Use `./docker-scripts.sh logs` to debug issues

---

**🎉 You're all set! The Rakshak Expense Management System is ready to use.** 