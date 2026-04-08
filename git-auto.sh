#!/bin/bash

# 1. 깃허브 비밀번호(토큰)를 한 번만 입력하면 기억하게 설정
git config --global credential.helper store

# 2. 최신 내용 가져와서 합치기 (오류 방지)
git pull origin main --rebase

# 3. 변경사항 담기
git add .

# 4. 커밋 메시지 입력받기
echo -n "커밋 메시지 입력 : "
read commitmsg

# 5. 깃허브로 올리기
git commit -m "$commitmsg"
git push origin main --force
