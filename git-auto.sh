#!/bin/bash

# 1. 깃허브에서 최신 내용 가져오기
git pull https://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@github.com/juminu85-source/linux-basics.git main --rebase

# 2. 변경사항 담기
git add .

# 3. 커밋 메시지 입력받기
echo -n "커밋 메시지 입력 : "
read commitmsg

# 4. 깃허브로 강제 전송 (토큰 주소 사용)
git commit -m "$commitmsg"
git push https://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@github.com/juminu85-source/linux-basics.git main --force
