# Contents of leif.io

Everything you see on [leif.io](https://leif.io) is built from this repository.

All articles are written in markdown and I use the static site generator [Hugo](https://gohugo.io) to build the HTML content. The theme I'm using is named [Congo](https://jpanther.github.io/congo/).

## Content Structure

All articles can be found under /blog and are in subfolders named after year/month/date. You won't find drafts here as I push them to a private repo.

Even the "Schlockchain" articles are contained in the `/blog` directory. Showing them on the Schlockchain page is implemented as a [Branch Bundle](https://gohugo.io/content-management/page-bundles/#branch-bundles). All blog posts with the tag `blockchain` are listed there. See the [custom layout](layouts/schlockchain/list.html) for the implementation.

## Deployment

The blog is deployed on [Netlify](https://www.netlify.com) and uses its [redirect feature](https://www.netlify.com) to forward from former URLs to not lose the SEO traffic.
