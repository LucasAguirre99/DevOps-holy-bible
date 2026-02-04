# Instalación de Powerlevel10k en Kubuntu

Realizo este tutorial ya que es el que me funcionó para la instalación en las distribuciones Kubuntu y xubuntu

## Paso 1: Instalar ZSH

```bash
sudo apt-get install zsh 
```

## Paso 2: Configurar ZSH como shell predeterminada 

```bash
chsh -s $(which zsh)
```

## Paso 3: Instalar Oh My ZSH
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Paso 4: Instalar las fuentes necesarias
```bash
sudo apt-get install fonts-powerline
```

## Paso 5: Clonar Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
```
## Paso 6: configurar Powerlevel10k como tema de ZSH
```bash
nano ~/.zshrc
```
Dentro del archivo debo de encontrar y reemplazar la linea que dice:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

## Paso 7: Instalar Nerd Fonts (Recomendado para iconos completos)
Las `fonts-powerline` básicas a veces no incluyen todos los glifos. Para una experiencia perfecta en P10k, instalamos MesloLGS NF vía consola:

```bash
	mkdir -p ~/.local/share/fonts
	wget -P ~/.local/share/fonts/ [https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
	wget -P ~/.local/share/fonts/ [https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
	wget -P ~/.local/share/fonts/ [https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
	wget -P ~/.local/share/fonts/ [https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)
	fc-cache -fv
```



