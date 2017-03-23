for style in base16 base16.dark base16.monokai base16.monokai.light base16.solarized base16.solarized.dark colorful github gruvbox gruvbox.light molokai monokai monokai.sublime thankful_eyes
do 
    rougify style $style > syntax.$style.css
done