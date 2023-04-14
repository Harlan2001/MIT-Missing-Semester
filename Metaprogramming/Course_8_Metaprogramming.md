1.Most makefiles provide a target called clean. This isn’t intended to produce a file called clean, but instead to clean up any files that can be re-built by make. Think of it as a way to “undo” all of the build steps. Implement a clean target for the paper.pdf Makefile above. You will have to make the target phony. You may find the git ls-files subcommand useful. A number of other very common make targets are listed here.

Write Makefile
```
paper.pdf: paper.tex plot-data.png
	pdflatex paper.tex

plot-%.png: %.dat plot.py
	./plot.py -i $*.dat -o $@

.PHONY: clean
clean:
	rm *.pdf *.aux *.log *.png
	#git ls-files -o | xargs rm -f
```

```shell
git ls-files -o | xargs rm -f 
```
It can list files that are not tracked by git, usually as an intermediate build, but of course you need to set git's ignore rules first.


2.Take a look at the various ways to specify version requirements for dependencies in Rust’s build system. Most package repositories support similar syntax. For each one (caret, tilde, wildcard, comparison, and multiple), try to come up with a use-case in which that particular kind of requirement makes sense.

3.Git can act as a simple CI system all by itself. In .git/hooks inside any git repository, you will find (currently inactive) files that are run as scripts when a particular action happens. Write a pre-commit hook that runs make paper.pdf and refuses the commit if the make command fails. This should prevent any commit from having an unbuildable version of the paper.

Modify the pre-commit.sample file under the.git/hooks directory and name it pre-commit
```
if  ! make ; then
     echo "build failed, commit rejected"
     exit 1
fi
```

4.Set up a simple auto-published page using GitHub Pages. Add a GitHub Action to the repository to run shellcheck on any shell files in that repository (here is one way to do it). Check that it works!

5.Build your own GitHub action to run proselint or write-good on all the .md files in the repository. Enable it in your repository, and check that it works by filing a pull request with a typo in it.

Modify blank.yml
```
# This is a basic workflow to help you get started with Actions

name: CI
...
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2
      # run shellcheck
      - name: ShellCheck
        uses: ludeeus/action-shellcheck@1.1.0
      - name: Post comment
        uses: mshick/add-pr-comment@v1
        if: $
        with:
            message: |
            $
            repo-token: $
            repo-token-user-login: 'github-actions[bot]' # The user.login for temporary GitHub tokens
            allow-repeats: false # This is the default
```
