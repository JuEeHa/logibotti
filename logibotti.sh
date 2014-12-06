#!/bin/sh

echo ':j #osdev-offtopic'
while true
do
	read LINE
	CMD=$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 5)
	case "$CMD" in
		"#lastseen")
			NICK="$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 6)"
			if test z"$NICK" != z
			then
				MSG="$(egrep -n "^..:.. <.$NICK>" ~/irclogs/freenode/\#osdev-offtopic.log | tail -n 1)"
				DAY=$(head -n $(echo $MSG | cut -d ':' -f 1) ~/irclogs/freenode/\#osdev-offtopic.log | grep '^--- Day changed ' | tail -n 1 | cut -d ' ' -f 4-)
				TIME=$(echo "$MSG" | cut -d ':' -f 2- | cut -d ' ' -f 1)
				echo $DAY $TIME
			else
				echo 'needs nick'
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
					sed '/^---/d' ~/irclogs/freenode/\#osdev-offtopic.log | sed '/^..:.. -!-/d' | fgrep "$Q" | head -n $MAXNUM | tail -n $SLINE | head -n 20 > ~/lblogs/$FNAME
				fi
				echo "gopher://smar.fi:7070/0/$FNAME"
				LNUM=
			fi
			;;
		"#quotes")
			echo "gopher://smar.fi:7070/0/quote (or for gopherless people: http://smar.fi:7070/quote)"
			;;
		"#wc")
			egrep -c "$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 6-)" ~/irclogs/freenode/\#osdev-offtopic.log
			;;
		"#help")
			topic=$(echo "$LINE" | cut -d ':' -f 2- | cut -d ' ' -f 6-)
			case "$topic" in
				'')
					echo ' #addquote #lastseen #quotes #wc'
					;;
				'#addquote')
					echo ' #addquote quote      add quote to #osdev-offtopic qdb (not a logibotti feature)'
					;;
				'#context')
					echo ' #context message      grep for message, generate link for looking up the context'
					;;
				'#quotes')
					echo ' #quotes      post link to quote database'
					;;
				'#lastseen')
					echo ' #lastseen nick      tell when the person was last seen. TZ is either UTC, +2 or +3'
					;;
				'#wc')
					echo ' #wc regexp      grep -c for regexp in logs'
					;;
			esac
			;;
	esac
done
