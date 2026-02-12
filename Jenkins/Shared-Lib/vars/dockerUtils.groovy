def build(imageName) {
    sh "docker build -t ${imageName} -f Docker/Dockerfile ."
}

def scan(imageName) {
    sh "trivy image --severity HIGH,CRITICAL ${imageName} || echo 'Scan failed but continuing...'"
}

def push(imageName, dockerhubcred) {
    withCredentials([usernamePassword(credentialsId: dockerhubcred, passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "echo \$PASS | docker login -u \$USER --password-stdin"
        sh "docker push ${imageName}"
    }
}

def clean(imageName) {
    sh "docker rmi ${imageName}"
}
