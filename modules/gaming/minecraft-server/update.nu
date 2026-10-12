#!/usr/bin/env nu

let loaders = '["fabric"]'
let game_versions = '["26.2"]'
let configPath = $"($env.FILE_PWD)/mods.json"
let modNames = open $configPath | columns

def getModInfo [name: string] {
    let modInfo = open $configPath | get $name

    $modInfo.url
    | parse "https://cdn.modrinth.com/data/{Mod ID}/versions/{Version ID}/{Filename}"
    | insert Name $name
    | move Name --first
    | insert Checksum ($modInfo | get sha512)
    | get 0
}

let allModInfo = $modNames
| each {|name| getModInfo $name}
| flatten

def getLatestVersion [name: string] {
    let modInfo = getModInfo $name
    let modId = $modInfo | get "Mod ID"

    let query = {loaders: $loaders, game_versions: $game_versions, include_changelog: false} | url build-query

    let response = http get -H [User-Agent "rnk-server-updater"] $"https://api.modrinth.com/v2/project/($modId)/version?($query)"
    | sort-by date_published --reverse
    | select 0

    let id = $response.id.0
    let url = $response.files.0.url.0
    let hash = $response.files.0.hashes.sha512.0

    {id: $id, url: $url, hash: $hash}
}

def main [--verbose] {
    $allModInfo
    | if $verbose { } else {
        select Name "Mod ID" "Version ID"
    }
    | print
}

def "main update" [names: list<string> = []] {
    for name in (if $names == [] { $modNames } else { $names }) {
        let currentVersionId = getModInfo $name | get "Version ID"
        let latestVersion = getLatestVersion $name

        if $currentVersionId != $latestVersion.id {
            print $"($name) has a new version: ($latestVersion.id)"
            open $configPath | update $name {url: $latestVersion.url, sha512: $latestVersion.hash} | save -f $configPath
        }
    }
}
