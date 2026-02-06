pipeline {
    agent any

    environment {
        DB_HOST = "host.docker.internal"
        DB_USER = "root"
        DB_PASS = "winjit3439"
        DB_NAME = "appdb"
        SNAPSHOT = "snapshot.sql"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/saurabhkulkarni12/jenkins-db-script.git'
            }
        }

        stage('Deploy Initial DB Script') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS < scripts/01_init.sql
                """
            }
        }

        stage('Update Stored Procedure') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS < scripts/02_update_sp.sql
                """
            }
        }

        stage('Take DB Snapshot') {
            steps {
                sh """
                mysqldump -h $DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME > $SNAPSHOT
                """
            }
        }

        stage('Deploy DB Script Again') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS < scripts/02_update_sp.sql
                """
            }
        }

        stage('Verify Stored Procedure Name') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS < verify/check_sp.sql
                """
            }
        }

        stage('Rollback (Restore Snapshot)') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME < $SNAPSHOT
                """
            }
        }

        stage('Verify After Rollback') {
            steps {
                sh """
                mysql -h $DB_HOST -u$DB_USER -p$DB_PASS < verify/check_sp.sql
                """
            }
        }
    }
}
