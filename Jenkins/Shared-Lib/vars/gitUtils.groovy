def updateManifest(filePath, imageName) {
    sh "sed -i 's|image:.*|image: ${imageName}|g' ${filePath}"
}

def pushChanges(github-creds) {
    withCredentials([gitUsernamePassword(credentialsId: github-creds)]) {
        sh """
            git config user.email "jenkins@ivolve.com"
            git config user.name "Jenkins Pipeline"
            git add .
            git commit -m 'Release: Update image tag [skip ci]'
            git push origin main
        """
    }
}
