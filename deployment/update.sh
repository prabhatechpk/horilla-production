#!/bin/bash
set -e

echo "=========================================="
echo "Horilla HRMS Update Script"
echo "=========================================="

# Get current version
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Backup database
echo "Creating database backup..."
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR
BACKUP_FILE="$BACKUP_DIR/db_backup_$(date +%Y%m%d_%H%M%S).sql"

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Backup database (PostgreSQL)
if [ ! -z "$DB_NAME" ]; then
    echo "Backing up database: $DB_NAME"
    pg_dump -U $DB_USER -h ${DB_HOST:-localhost} $DB_NAME > $BACKUP_FILE
    echo "Backup saved to: $BACKUP_FILE"
fi

# Ask for target version
echo ""
echo "Available versions from upstream:"
git fetch upstream --tags
git tag -l | tail -10
echo ""
read -p "Enter version to update to (e.g., 1.5.0): " NEW_VERSION

# Confirm
read -p "Update from current version to v$NEW_VERSION? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Update cancelled."
    exit 0
fi

# Create update branch
UPDATE_BRANCH="update-to-v$NEW_VERSION"
echo "Creating update branch: $UPDATE_BRANCH"
git checkout -b $UPDATE_BRANCH

# Merge new version
echo "Merging v$NEW_VERSION from upstream..."
git merge tags/$NEW_VERSION --no-edit || {
    echo ""
    echo "=========================================="
    echo "MERGE CONFLICTS DETECTED!"
    echo "=========================================="
    echo "Please resolve conflicts manually:"
    echo "1. Fix conflicts in the files listed above"
    echo "2. git add <resolved-files>"
    echo "3. git commit"
    echo "4. Run: ./deployment/deploy.sh"
    echo "5. Test the application"
    echo "6. git checkout production && git merge $UPDATE_BRANCH"
    echo "=========================================="
    exit 1
}

# Run deployment
echo "Running deployment..."
./deployment/deploy.sh

echo ""
echo "=========================================="
echo "Update completed successfully!"
echo "=========================================="
echo "Next steps:"
echo "1. Test the application thoroughly"
echo "2. If everything works:"
echo "   git checkout production"
echo "   git merge $UPDATE_BRANCH"
echo "   git push origin production"
echo "3. If there are issues:"
echo "   git checkout production"
echo "   git branch -D $UPDATE_BRANCH"
echo "   # Restore database from: $BACKUP_FILE"
echo "=========================================="
