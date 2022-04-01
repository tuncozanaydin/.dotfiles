# .dotfiles
Clone as a bare repository so that all files are places appropriately

git clone --bare https://github.com/<username>/dotfiles.git $HOME/.dotfiles 
  
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
