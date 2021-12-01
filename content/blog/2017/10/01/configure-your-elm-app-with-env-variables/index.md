---
title: Configure your Elm app with ENV variables
date: 2017-10-01T21:53:54+00:00
draft: false
tags: [elm]
categories: [programming]
---

[Create Elm App](https://github.com/halfzebra/create-elm-app) makes it very easy to get started with Elm because it provides a zero configuration application that just works.

However sometimes it is very useful to have some kind of configuration in your app. The example that I recently ran into is making your backend api url configurable. Or do you really want to develop against your production API?

Lucky for you [Create Elm App](https://github.com/halfzebra/create-elm-app) already comes with all necessary tools. It's kinda tricky to find and that's why I'm writing this post.

Let's go ahead and leverage environment variables for configuration.

First we need to decide which variables to use. All env variables starting with `ELM_APP_` will be accessible within our `index.js` file. We can then pass this into our Elm app by

```javascript
Main.embed(document.getElementById('root'), {
    url: process.env.ELM_APP_API_URL,
});
```


Additionally we need to expose these parameters within the Elm app. Let's just add a simple model called `Config`:

```elm
type alias Config =
    { api_url : String
    }
```


To actually pass the parameters into this model we need to flags of the [Elm JavaScript Interop](https://guide.elm-lang.org/interop/javascript.html) feature.

Therefore we need to use [Html.programWithFlags](http://package.elm-lang.org/packages/elm-lang/html/latest/Html#programWithFlags). The config will then be an argument of the init function:

```elm
main : Program Config Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }

init : Config -> ( Model, Cmd Msg )
init config =
    ( initialModel config, Cmd.none)
```

Inside your `initialModel` function you'll now have access to the config model:

```elm
initialModel : Config -> Model
initialModel config =
    { otherFields = []
    , config = config
    }
```


Now all you have to do is make sure the environment variable `ELM_APP_API_URL` is set before starting the server or building the app.

For your local development you can just create a `.env` file in your project

```shell
ELM_APP_API_URL=http://localhost:4000
```


For production use make sure this variable is set before running the `build` command:

```shell
ELM_APP_API_URL=https://the-real-api.com elm-app build
```


Thanks to [bekapod](https://github.com/bekapod) for pointing out this neat trick in a related [Github issue](https://github.com/halfzebra/create-elm-app/issues/178#issuecomment-331233589)
