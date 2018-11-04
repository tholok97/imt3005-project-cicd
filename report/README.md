# Report for project

Based on template by lecturer.

To duplicate my LaTeX installation:

```basH
apt install texlive-latex-extra
apt install python-pygments
```

I use the script `./c.sh` to produce the pdf. I use this mapping to invoke script from inside vim:

```vim
nnoremap ø :!./c.sh<cr>
```

## TODO

- [x] Citations
  - [x] Setting up bibtex file
  - [x] Citations in tex file
- [x] Add appendices
- [ ] Proof-reading
  - [x] Proof-read for missing citations
- [x] write about webhooks in Skyhigh
- [ ] Write about how I wrote the report?
- [ ] Make citations consitent with regards to space or no space
