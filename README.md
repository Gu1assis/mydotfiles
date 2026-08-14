# 🛠️ My Dotfiles

Repositório pessoal para versionamento e sincronização de arquivos de configuração (*dotfiles*) entre múltiplos dispositivos e distribuições Linux.

---

## 💡 Como Funciona (Arquitetura)

Este repositório utiliza a abordagem de **Bare Git Repository com Work-Tree Customizada**. 

### Por que esta abordagem?

1. **Sem Redundância:** Não há necessidade de usar scripts de `rsync`, cópias manuais ou *symlinks* (como no GNU Stow). Os arquivos vivem onde sempre viveram (ex: `~/.bashrc`, `~/.config/waybar/`).
2. **Isolamento da Home:** O repositório Git vive em uma pasta oculta separada (`~/.dotfiles`), mas a *Work-Tree* (sua árvore de trabalho) aponta diretamente para a pasta `$HOME` (`~`).
3. **Filtro Estrito:** A flag local `status.showUntrackedFiles no` faz com que o Git ignore a home inteira por padrão, rastreando **apenas** os arquivos que foram explicitamente adicionados via `dotfiles add`.

---

## 🚀 Como Restaurar/Configurar em uma Máquina Nova

Quando você instalar um sistema novo e quiser puxar suas configurações:

### 1. Adicionar a pasta `.dotfiles` ao `.gitignore` global (Prevenção)
Para evitar recursões acidentais, garanta que a home ignore a própria pasta do repositório:
```bash
echo ".dotfiles" >> ~/.gitignore
```

### 2. Clonar o repositório como Bare
Clone o repositório remoto apontando para a pasta oculta `~/.dotfiles`:
```bash
git clone --bare git@github.com:seu-usuario/seu-repositorio.git $HOME/.dotfiles
```

### 3. Criar o Alias Temporário
Crie o alias na sessão atual do terminal para conseguir operar o repositório:
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 4. Ocultar arquivos não rastreados
Configure para que o `git status` não mostre a sua pasta home inteira:
```bash
dotfiles config --local status.showUntrackedFiles no
```

### 5. Baixar as Configurações (Checkout)
Puxe a branch do sistema que você quer usar (ex: `gentoo`):
```bash
dotfiles checkout gentoo
```

> ⚠️ **Atenção (Conflitos do Checkout):** 
> Se o sistema recém-instalado já criou arquivos padrão (como um `~/.bashrc`), o `checkout` pode retornar um erro informando que arquivos seriam sobrescritos. Faça backup dos arquivos locais existentes ou remova-os e rode o `checkout` novamente.

---

## 🔄 Fluxo de Trabalho no Dia a Dia

Uma vez configurado, você usará o alias `dotfiles` **exatamente igual** ao comando `git`.

### 1. Adicionar o Alias Definitivo
Garanta que o alias esteja no seu `~/.bashrc` (ou arquivo de config do seu shell):
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 2. Adicionar/Modificar Arquivos
> ⛔ **REGRA DE OURO:** NUNCA use `dotfiles add .` ou `dotfiles add ~/.config`. Sempre adicione arquivos ou subpastas específicas.

```bash
# Adicionar alterações em arquivos específicos
dotfiles add ~/.bashrc
dotfiles add ~/.config/waybar/

# Ver alterações pendentes
dotfiles status

# Criar commit
dotfiles commit -m "feat: ajusta atalhos do sway e estilo do waybar"

# Enviar alterações para a branch atual
dotfiles push
```

### 3. Alternar entre Ambientes (Branches)
Se você tiver branches para diferentes sistemas (ex: `gentoo`, `arch`, `work-laptop`):

```bash
# Ver branches disponíveis
dotfiles branch -a

# Alternar para outra branch
dotfiles checkout nome-da-branch

# Trazer alterações comuns da branch principal (ex: main -> gentoo)
dotfiles merge main
```
### 🛡️ Ferramentas e Proteções Embutidas

A função `dotfiles` no `~/.bashrc` inclui mecanismos de segurança e atalhos de sincronização rápida:

#### 1. Sincronização em um Único Comando (`sync`)
Para salvar e enviar alterações rápidas em arquivos **já rastreados** (ex: editou o `.bashrc` ou `.vimrc`):

```bash
dotfiles sync "feat: atualiza aliases e configurações do vim"
```
*(Executa automaticamente `add -u`, `commit` e `push`).*

#### 2. Travas do Sistema Anti-Burrice
- **Adição Massiva Bloqueada:** Comandos como `dotfiles add .` ou `dotfiles add ~/.config` são interrompidos automaticamente para evitar o vazamento de credenciais ou poluição do repositório.
- **Deleção Física Impedida:** O comando `dotfiles rm` exige obrigatoriamente a flag `--cached` para garantir que nenhum arquivo do seu disco rígido seja apagado acidentalmente.
