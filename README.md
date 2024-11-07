# IDE
- vscode
- extention : docker(Dockerfile build)

___
# docker install
### window
- [Download Docker Desktop Installer](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-win-amd64&_gl=1*1s34xib*_ga*OTQ4MDcyNjk2LjE3MzA2OTQxNTA.*_ga_XJWPQMJYHQ*MTczMDk4NTUwMy4zLjEuMTczMDk4NTUwNC41OS4wLjA.)
- confirm your email address
### linux
-     sudo apt-get update
      sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io

# git
### window
- [Download sourceTree Installer](https://product-downloads.atlassian.com/software/sourcetree/windows/ga/SourceTreeSetup-3.4.20.exe)

### linux
-     sudo apt-get update
      sudo apt-get install git
-     SSH 디렉토리 생성
      mkdir ~/.ssh
      chmod 700 ~/.ssh
      cd ~/.ssh
-     SSH Key생성
      ssh-keygen -t rsa -b 4096 -C "GitHub Email@example.com"
      -t rsa: rsa 암호화 방식으로 키를 생성
      메일 계정은 GitHub에 등록한 이메일 주소
      SSH Key를 생성시 암호 등 설정 안할꺼면 입력하지말고 엔터키를 누르면 됨
      혹시 비밀번호를 설정했으면, 다음 명령어를 통해 비밀번호를 재생성(ssh-keygen -p)
-     SSH 에이전트 실행 및 SSH 키 추가
      eval "$(ssh-agent -s)"
-     SSH 키 추가
      ssh-add ~/.ssh/id_rsa
-     SSH 공개 키를 GitHub에 추가(settings -> SSH and GPG keys)
      cat ~/.ssh/id_rsa.pub
-     GitHub 연결 테스트
      ssh -T git@github.com




  
