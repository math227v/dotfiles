# Mine Dotfiles

Mit personlige og stadigt udviklende setup for en produktiv og behagelig udviklingsoplevelse. Målet er at kunne sætte en ny maskine op på minutter og have et konsistent miljø på tværs af alle mine systemer.

![Min Terminal](https://via.placeholder.com/800x400.png?text=Indsæt+et+flot+screenshot+af+din+terminal+her)

## Filosofi: Hvorfor `stow`?

Dette repository bruger [GNU Stow](https://www.gnu.org/software/stow/) til at administrere alle konfigurationsfiler (dotfiles). I stedet for at bruge komplekse installationsscripts, der manuelt kopierer filer eller opretter symlinks, udnytter vi `stow`s simple og geniale tilgang.

**Kerneideen:**
Hvert program (som `bash` eller `starship`) behandles som en "pakke" i sin egen mappe. Strukturen i pakke-mappen afspejler præcis, hvordan filerne skal ligge i din hjemmemappe (`~/`).

Når du kører `stow bash`, kigger `stow` i `bash`-mappen og opretter automatisk symlinks fra filerne dér til de korrekte placeringer i din hjemmemappe.

Fordelene er:
- **Simplicitet:** Ingen komplekse scripts at vedligeholde.
- **Modularitet:** Nemt at tilføje eller fjerne en hel konfiguration.
- **Renlighed:** Roden af dit dotfiles-repo indeholder kun pakke-mapper.

## Installation

Opsætning på en ny maskine er designet til at være hurtig og smertefri.

### 1. Forudsætninger

Sørg for, at du har `git` og `stow` installeret.

```bash
# På Debian/Ubuntu
sudo apt update && sudo apt install git stow

# På macOS (med Homebrew)
brew install git stow
```

### 2. Installationstrin

1.  **Klon repository'et** til den korrekte placering:
    ```bash
    git clone https://github.com/DIT_BRUGERNAVN/dotfiles.git ~/dotfiles
    ```

2.  **Naviger ind i mappen:**
    ```bash
    cd ~/dotfiles
    ```

3.  **Kør installationsscriptet:**
    Dette script bruger `stow` til at oprette symlinks for alle pakkerne. `-R` (`--restow`) sikrer, at eksisterende links bliver opdateret korrekt.
    ```bash
    # Kør det medfølgende script, der stower alle pakker
    ./scripts/install.sh
    ```
    *Alternativt kan du stowe pakker manuelt:*
    ```bash
    # Stow alle pakkerne enkeltvis
    stow bash starship
    ```

Din maskine er nu konfigureret! Åbn en ny terminal for at se ændringerne træde i kraft.

---

## **Sådan Tilføjer du Nye Dotfiles (Vigtigt!)**

Dette er din guide til at udvide dit setup. Den bedste metode er at bruge `stow`s geniale `adopt`-funktion.

### Trin 1: Opret en tom pakke-mappe

Lad os sige, du vil tilføje din `git`-konfiguration, som ligger i `~/.gitconfig`.
Først opretter du en tom mappe til den nye pakke i dit dotfiles-repo:

```bash
mkdir ~/dotfiles/git
```

### Trin 2: Lad `stow` adoptere filen

Naviger til roden af dit dotfiles-repo. Kør `stow --adopt` på den nye pakke.

```bash
cd ~/dotfiles
stow --adopt git
```

**Hvad sker der nu?**
`stow` vil finde den eksisterende `~/.gitconfig`-fil, **flytte** den ind i din `~/dotfiles/git/`-mappe for dig, og derefter automatisk oprette et symlink, der peger fra den oprindelige placering til den nye. Din fil er nu under Git-kontrol uden manuelt flytteri.

### Trin 3: Commit dine ændringer

Glem ikke at gemme dit arbejde i Git!

```bash
git add git/
git commit -m "feat: Add git configuration via adopt"
git push
```

Du har nu succesfuldt tilføjet og versioneret en ny konfiguration på den mest effektive måde.

## Inkluderede Værktøjer

Denne konfiguration indeholder opsætning for:
- **Shell:** `bash` (med diverse aliaser og funktioner)
- **Prompt:** `starship` (en minimalistisk og lynhurtig cross-shell prompt)
