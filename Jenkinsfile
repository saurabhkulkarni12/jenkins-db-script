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
                mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS < scripts/01_init.sql
                """
            }
        }
        stage('Verify Output After Initial Deployment') {
            steps {
                sh """
                RESULT=\$(mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS -N -e "CALL get_user();" $DB_NAME)
                [ "\$RESULT" = "Version 1" ] || exit 1
                """
            }
        }

        stage('Take DB Snapshot') {
            steps {
                sh """
                mysqldump --ssl=0 --routines --triggers --events -h $DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME > $SNAPSHOT
                """
            }
        }

        stage('Update Stored Procedure') {
            steps {
                sh """
                mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS < scripts/02_update_sp.sql
                """
            }
        }

       stage('Verify Stored Procedure Output (After Update)') {
           steps {
               sh """
               mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS < verify/check_sp_output.sql
              """
           }
       }


        stage('Rollback (Restore Snapshot)') {
            steps {
                sh """
                mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME < $SNAPSHOT
                """
            }
        }

        /*stage('Verify Output After Rollback') {
            steps {
                sh """
                mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS < verify/check_sp_output.sql
                """
            }
        }*/
        stage('Verify Output After Rollback (Gate)') {
            steps {
                sh """
                RESULT=\$(mysql --ssl=0 -h $DB_HOST -u$DB_USER -p$DB_PASS -N -e "CALL get_user();" $DB_NAME)
                echo "Stored Procedure Output After Rollback: \$RESULT"

                if [ "\$RESULT" != "Version 1" ]; then
                    echo "❌ Rollback validation failed!"
                    exit 1
                fi

                echo "✅ Rollback validation successful"
                """
            }
        }


    }
}
