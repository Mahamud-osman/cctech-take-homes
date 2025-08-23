# DevSecOps ECS Take-Home Assessment - Troubleshooting Notes

## Two Biggest Deployment Issues

Based on our troubleshooting journey, the **two biggest issues** that blocked deployment were:

### 1. Docker Architecture Mismatch 🐳
**Problem**: Tasks kept failing with "exec format error"
- **Root Cause**: Docker image was built for ARM64 (Apple Silicon) but ECS Fargate needed x86_64
- **Symptoms**: Tasks would start but immediately crash before reaching running state
- **Impact**: Prevented any application functionality - complete deployment failure
- **Fix**: Rebuilt Docker image with `--platform linux/amd64` flag

### 2. Database Connection Failure 🗄️  
**Problem**: Application couldn't connect to RDS PostgreSQL
- **Root Cause #1**: `DB_HOST` included port (`:5432`) causing DNS resolution failure (`ENOTFOUND` errors)
- **Root Cause #2**: AWS RDS self-signed SSL certificates rejected by Node.js client
- **Symptoms**: API returning "Failed to connect to the database" even though infrastructure was correct
- **Impact**: Application ran but core functionality (database operations) completely broken
- **Fix**: 
  - Changed database output from `endpoint` to `address` (removed port from hostname)
  - Added `PGSSLMODE=require` + `NODE_TLS_REJECT_UNAUTHORIZED=0` for SSL handling

### Why These Were the Biggest Issues:
1. **Architecture mismatch** = **Complete deployment failure** (nothing worked)
2. **Database connection** = **Application failure** (infrastructure worked but app was broken)

Both issues required deep debugging through AWS logs and understanding of underlying technologies (Docker platforms, PostgreSQL SSL behavior). Everything else was configuration tweaks, but these two were fundamental blockers.

## Final Status: ✅ COMPLETE
- Infrastructure: 100% deployed via Terraform
- Application: Fully accessible via ALB
- Database: Successfully connected with SSL
- All requirements met for DevSecOps assessment