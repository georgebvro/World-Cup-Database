#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo "$($PSQL "truncate table games, teams")"
cat games.csv | while IFS=="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  echo "Game data read: $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
  #insert winning team into TEAMS table
  if [[ $WINNER != winner ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo -e "${RED}>>> Inserted into teams: $WINNER <<<${NC}"
      fi
    fi
  fi
  #insert opponent team into TEAMS table
  if [[ $OPPONENT != opponent ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo -e "${RED}>>> Inserted into teams table: $OPPONENT <<<${NC}"
      fi
    fi
  fi
  #get IDs for both teams
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  #insert game into GAMES table
  INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
  then
    echo -e "${GREEN}>>> Inserted into games table: $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS <<<${NC}"
  fi
done


