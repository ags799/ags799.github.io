---
title: "A Glossary of Security-Related Terms"
layout: post
date: 2021-01-20
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- security
- https
- ssl
- tls
- certificate
- x509
- ca
- public key
- private key
- encryption
- cryptography
category: blog
author: andrew
description: Help navigating the vast ocean of security-related terms.
---

Computer security can feel like a vast ocean of technologies and terms. This glossary serves as a star-chart for the
wayward sailor.


# Certificate
A certificate does a few things:
1. It identifies the owner in human-readable terms.
1. It carries the owner's public key.
1. It might be signed by a trusted [Certificate Authority](#CA: Certificate Authority).
1. It might instead by self-signed. This is common in development scenarios.


# CA: Certificate Authority
Issues [certificates](#Certificate).

For example, your browser comes installed with a list of trusted Certificate Authorities, like the Google CA. It uses
these CAs to determine if a website's certificate can be trusted.


# CSR: Certificate Signing Request
Issued to a [CA](#CA: Certificate Authority) by a website when it wants to get a [certificate](#Certificate) from that
CA.


# HTTPS
TODO


# PEM
PEM is a file format for holding cryptographic information. It looks like this:
```
-----BEGIN RSA PRIVATE KEY-----
lotsOfRandomText
12345
-----END RSA PRIVATE KEY-----
```


# Public-Key Cryptography
Also known as _assymetric cryptography_.

1. A server has a public key and a private key.
1. A client requests the public key.
1. The client encrypts a message with the public key.
1. Only the private key can decrypt it.


# PKI: Public-Key Infrastructure
The mapping of [public keys](#Public-Key Cryptography) to the entities that "own" them.

For example, if I wanted you to send me an encrypted email that only I could read, I'd give you my public key. A PKI
would maintain the mapping between myself and my public key.

This is normally handled by a [Certificate Authority](#CA: Certificate Authority).


# Root Certificate
Let's say an organization doesn't want to establish trust using an existing [CA](#CA: Certificate Authority), and they
don't want to be prone to man-in-the-middle attacks by using self-signed [certificates](#Certificate).

They can set up their own CA. We say that this is a _self-signed CA_ because it doesn't carry the signature of one of the
commonly-accepted CAs. It does, however, carry a _root certificate_. This root certificate is to be used by the
organization's clients in verifying the certificates of the organization's servers.


# SSL
Stands for _Secure Sockets Layer_.


Starts with public-key cryptography to exchange a secret, which is then used for symmetric encryption.
TODO


# TLS
TODO


# X.509
TODO, make sure to mention "X.509 Certificate".
