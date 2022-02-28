# Andrew Sharp's Personal Website
https://sharpandrew.com

## Development
- Environment setup is handled by [nix-direnv](https://github.com/nix-community/nix-direnv).
    - Friendly reminder to run `direnv allow` after cloning.
- You should not edit `index.html`, edit `index.html.tmpl` instead.
- Some information is duplicated, and we use `config.yml` and
  [gomplate](https://github.com/hairyhenderson/gomplate) to de-duplicate.
- Update `index.html` with `make`.
