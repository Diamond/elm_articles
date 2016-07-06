module Hop.LocationTest exposing (..)

import Dict
import Hop.Types as Types
import Hop.Location as Location
import ElmTest exposing (..)


type Route
    = NotFound


config =
    { hash = True
    , basePath = ""
    , matchers = []
    , notFound = NotFound
    }


configWithPath =
    { config | hash = False }


configWithPathAndBase =
    { configWithPath | basePath = "/app/v1" }


fromUrlTest =
    let
        inputs =
            [ ( "it parses an empty hash"
              , config
              , "http://localhost:3000/basepath"
              , { path = [], query = Dict.empty }
              )
            , ( "it parses a hash"
              , config
              , "http://localhost:3000/basepath#/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a path"
              , configWithPath
              , "http://localhost:3000/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a path with basepath"
              , configWithPathAndBase
              , "http://localhost:3000/app/v1/users/1"
              , { path = [ "users", "1" ], query = Dict.empty }
              )
            , ( "it parses a hash with query"
              , config
              , "http://localhost:3000/basepath#/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it parses a path with query"
              , configWithPath
              , "http://localhost:3000/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it parses a path with basepath and query"
              , configWithPathAndBase
              , "http://localhost:3000/app/v1/users/1?a=1"
              , { path = [ "users", "1" ], query = Dict.singleton "a" "1" }
              )
            , ( "it decodes the query"
              , config
              , "http://localhost:3000/basepath#/?a%20b%26c%3Fd=1%202%263%3F4"
              , { path = [], query = Dict.singleton "a b&c?d" "1 2&3?4" }
              )
            ]

        run ( testCase, config, href, expected ) =
            let
                actual =
                    Location.fromUrl config href

                result =
                    assertEqual expected actual
            in
                test testCase result
    in
        suite "fromUrl" (List.map run inputs)


parseTest =
    let
        inputs =
            [ ( "it parses", "/users/1?a=1", { path = [ "users", "1" ], query = Dict.singleton "a" "1" } )
            ]

        run ( testCase, location, expected ) =
            let
                actual =
                    Location.parse location

                result =
                    assertEqual expected actual
            in
                test testCase result
    in
        suite "parse" (List.map run inputs)


locationToFullPathTest =
    let
        config =
            { basePath = ""
            , hash = True
            , matchers = []
            , notFound = NotFound
            }

        configWithPath =
            { config | hash = False }

        configPathAndBasePath =
            { configWithPath | basePath = "/app/v1" }

        empty =
            Types.newLocation

        inputs =
            [ ( "hash: it is empty when empty"
              , config
              , empty
              , "#/"
              )
            , ( "path: it is empty when empty"
              , configWithPath
              , empty
              , "/"
              )
            , ( "basepath: it has the basepath"
              , configPathAndBasePath
              , empty
              , "/app/v1"
              )
            , ( "basepath: adds slash when missing"
              , { configPathAndBasePath | basePath = "app/v1" }
              , empty
              , "/app/v1"
              )
              -- path
            , ( "hash: it adds the path"
              , config
              , { empty | path = [ "a", "b" ] }
              , "#/a/b"
              )
            , ( "path: it adds the path"
              , configWithPath
              , { empty | path = [ "a", "b" ] }
              , "/a/b"
              )
            , ( "path: it adds the basepath and path"
              , configPathAndBasePath
              , { empty | path = [ "a", "b" ] }
              , "/app/v1/a/b"
              )
              -- query
            , ( "hash: it adds the query as pseudo query"
              , config
              , { empty | query = Dict.singleton "k" "1" }
              , "#/?k=1"
              )
            , ( "path: it adds the query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1" }
              , "/?k=1"
              )
            , ( "path: it adds the basepath query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1" }
              , "/app/v1?k=1"
              )
              -- path and query
            , ( "hash: it adds the path and query"
              , config
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "#/a/b?k=1"
              )
            , ( "path: it adds the path and query"
              , configWithPath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/a/b?k=1"
              )
            , ( "path: it adds the basepath, path and query"
              , configPathAndBasePath
              , { empty | query = Dict.singleton "k" "1", path = [ "a", "b" ] }
              , "/app/v1/a/b?k=1"
              )
            , ( "hash: it encodes"
              , config
              , { empty | query = Dict.singleton "a b&c?d" "1 2&3?4", path = [] }
              , "#/?a%20b%26c%3Fd=1%202%263%3F4"
              )
            ]

        run ( testCase, config, location, expected ) =
            let
                actual =
                    Location.locationToFullPath config location

                result =
                    assertEqual expected actual
            in
                test testCase result
    in
        suite "locationToFullPath" (List.map run inputs)


all : Test
all =
    suite "Location"
        [ fromUrlTest
        , parseTest
        , locationToFullPathTest
        ]
