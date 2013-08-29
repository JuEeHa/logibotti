#!/bin/sh

echo ':j #osdev-offtopic'
while true
do
	read LINE
	CMD=$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 5)
	case "$CMD" in
		"#lastseen")
			NICK=$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 6)
			if test z"$NICK" != z
			then
				MSG="$(grep -n "^..:.. <.$NICK>" ~/irclogs/freenode/\#osdev-offtopic.log | tail -n 1)"
				DAY=$(head -n $(echo $MSG | cut -d ':' -f 1) ~/irclogs/freenode/\#osdev-offtopic.log | grep '^--- Day changed ' | tail -n 1 | cut -d ' ' -f 4-)
				TIME=$(echo "$MSG" | cut -d ':' -f 2- | cut -d ' ' -f 1)
				echo $DAY $TIME
			else
				echo 'needs nick'
			fi
			;;
		"#quote")
			Q=$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 6- | sed 's/$//g')
			if test z"$Q" != z
			then
				MAXNUM=$(sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | grep -c "$Q")
				LNUM=$(($RANDOM%$MAXNUM))
				sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | grep "$Q" | tail -n $LNUM | head -n 1
			else
				MAXNUM=$(sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | wc -l)
				LNUM=$(($RANDOM%$MAXNUM))
				sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | tail -n $LNUM | head -n 1
				Q=
			fi
			;;
		"#context")
			if test z$LNUM != z
			then
				SLINE=$(($LNUM+10))
				FNAME=
				while test -e ~/lblogs/$FNAME
				do
					FNAME=$(dd if=/dev/urandom of=/dev/stdout bs=256 count=1 2>/dev/null| md5sum | head -c 8)
				done
				if test z"$Q" = z""
				then
					sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | head -n $MAXNUM | tail -n $SLINE | head -n 20 > ~/lblogs/$FNAME
				else
					sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | grep "$Q" | head -n $MAXNUM | tail -n $SLINE | head -n 20 > ~/lblogs/$FNAME
				fi
				echo "gopher://smar.fi:7070/0/$FNAME"
				LNUM=
			fi
			;;
		esac
done
