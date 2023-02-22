pipeline {
    agent any 
    
    stages{
        stage('test on dev'){
            steps{
                sh 'python3 demo.py'
            }
        }
        stage('test on stage'){
            steps{
                sh 'python3 demo.py'
            }
        }

        stage('test on prod'){
            steps{
                sh 'python3 demo.py'
            }
        }
    }

    
}


// piepline {
//     agent any {
    
//     stages{
//         stage('test on dev'){
//             steps{
//                 sh 'python demo.py'
//             }
//         }
//         stage('test on stage'){
//             steps{
//                 sh 'python demo.py'
//             }
//         }

//         stage('test on prod'){
//             steps{
//                 script{

//                 }
                
//             }
//         }
//     }

//     }
// }
