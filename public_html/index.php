<?php

require_once "inc/functions.php";

$players = $groups = $teams = [];

foreach (glob("../tf/addons/sourcemod/data/vltbriefcase/player/*") as $intelligence) {

    $players[] = player2array($intelligence);

}

foreach (glob("../tf/addons/sourcemod/data/vltbriefcase/team/*") as $intelligence) {

    $teams[] = team2array($intelligence);

}

$sort_by = $_GET["sort_by"] ?? "kills";
$sort_dir = $_GET["sort_dir"] ?? "desc";

usort($players, function ($a, $b) use ($sort_by, $sort_dir) {

    $result = $a[$sort_by] <=> $b[$sort_by];

    return $sort_dir === "desc" ? -$result : $result;

});

if (isset($_GET["group_teams"])) {

    foreach ($players as $player) {

        $groups[$player["team"]["id"]][] = $player;

    }

    $players = $groups;

}

foreach (glob("../scripts/getinstats/team/stat/*") as $stat) {

    $teams[] = team2array($stat);

}

$response = [
    "map" => map2array("../tf/addons/sourcemod/data/vltbriefcase/map"),
    "players" => $players,
    "teams" => array_reverse($teams)
];

header("Content-Type: application/json; charset=utf-8");
http_response_code(200);

print json_encode($response, JSON_PRETTY_PRINT);