echo -e "\e[96;1mDeveloppSoft \e[94m<developpsoft.github.io>\e[0m"

echo ""

echo -e "\e[92m[\e[93m*\e[92m] \e[34mStarting postgresql...\e[0m"
su postgres -c "cd ~/DB && pg_ctl -D ./ -w start"

echo ""

/bin/ash
