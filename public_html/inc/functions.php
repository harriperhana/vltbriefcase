<?php

function player2array(string $file): array {

    $intelligence = parse_ini_file($file);

    $intelligence = array_diff_key($intelligence, array_flip(["ip", "steamid"]));

    $intelligence = array_map(function ($value) {

        return is_numeric($value) ? intval($value) : $value;

    }, $intelligence);

    $intelligence["class"] = [
        "id" => $intelligence["class"],
        "name" => get_classrole($intelligence["class"])
    ];

    $intelligence["team"] = [
        "id" => $intelligence["team"],
        "name" => get_team($intelligence["team"])
    ];

    return $intelligence;

}

function team2array(string $file): array {

    $intelligence = parse_ini_file($file);

    $intelligence = array_map(function ($value) {

        return is_numeric($value) ? intval($value) : $value;

    }, $intelligence);

    $intelligence["name"] = get_team($intelligence["id"]);

    return $intelligence;

}

function map2array(string $file): array {

    return array_map(function ($value) {

        return is_numeric($value) ? intval($value) : $value;

    }, parse_ini_file($file));

}

function get_team(int $id): string {

    return [
        2 => "RED",
        3 => "BLU"
    ][$id] ?? "";

}

function get_classrole(int $id): string {

    return [
        0 => "",
        1 => "Scout",
        2 => "Sniper",
        3 => "Soldier",
        4 => "Demoman",
        5 => "Medic",
        6 => "Heavy",
        7 => "Pyro",
        8 => "Spy",
        9 => "Engineer"
    ][$id] ?? "";

}