def build(imageName) {
    sh "docker build -t ${imageName} -f Docker/Dockerfile ."
}

def scan(imageName) {
    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${imageName}"
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
