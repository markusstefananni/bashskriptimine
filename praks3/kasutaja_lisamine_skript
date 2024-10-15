#!/bin/bash

# Funktsioon veateadete jaoks, et kuvada mugavalt vigu
show_error() {
    echo "Viga: $1"
}

# Funktsioon kasutaja loomise ja seadistamise jaoks
create_user() {
    local username="$1"  # Sisestatud kasutajanimi
    local group="$2"     # Sisestatud grupp, kas "opilased" või "opetajad"

    # Kontrollime, kas kasutajanimi vastab Linuxi kasutajanime nõuetele:
    # peab algama tähe või alakriipsuga, sisaldama väikseid tähti, numbreid, alakriipse või sidekriipse
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        show_error "Vale kasutajanimi. Kasutajanimi peab algama tähe või alakriipsuga ja sisaldama ainult väikseid tähti, numbreid, alakriipse ja sidekriipse."
        return 1  # Tagastame veakoodi ja lõpetame funktsiooni täitmise
    fi

    # Kontrollime, kas kasutaja juba eksisteerib süsteemis
    if id "$username" &>/dev/null; then
        show_error "Kasutaja $username on juba süsteemis olemas."
        return 1  # Kui kasutaja on juba olemas, lõpetame funktsiooni täitmise
    fi

    # Kontrollime, kas sisestatud grupp on kas "opilased" või "opetajad"
    if [[ "$group" != "opilased" && "$group" != "opetajad" ]]; then
        show_error "Vale grupi nimi. Peab olema 'opilased' või 'opetajad'."
        return 1  # Kui sisestatud grupp on vale, lõpetame funktsiooni täitmise
    fi

    # Loome kasutaja koos kodukataloogiga ja määrame selle grupi
    sudo useradd -m -s /bin/bash -g "$group" "$username"
    if [[ $? -ne 0 ]]; then
        # Kui kasutaja loomine ebaõnnestub, kuvame veateate ja lõpetame
        show_error "Kasutaja loomine ebaõnnestus."
        return 1
    fi

    # Kasutajale parooli määramine. "passwd" käsk küsib kaks korda parooli.
    echo "Määrame kasutajale $username parooli:"
    sudo passwd "$username"

    # Määrame kodukataloogile õige omaniku ja grupi, nii et kasutaja oleks kataloogi omanik ja kuuluks õigele grupile
    sudo chown "$username":"$group" /home/"$username"
    # Määrame kodukataloogile õigused: omanikul on täielik ligipääs (lugemine, kirjutamine, käivitamine),
    # grupil ja teistel on ainult lugemisõigus ja ligipääs kataloogile (755 õigused).
    sudo chmod 755 /home/"$username"

    # Kuvame loodud kasutaja andmed pärast edukat loomist
    echo "Kasutaja $username on edukalt loodud:"
    echo "Nimi: $username"
    echo "Grupp: $group"
    echo "Kodukataloog: /home/$username"
    echo "Shell: /bin/bash"
    echo "Kodukataloogi õigused ja omanik määratud."

    return 0  # Tagastame eduka lõpetamise
}

# Peamine tsükkel, mis töötab seni, kuni kasutaja vajutab "X" või "x", et lõpetada
while true; do
    # Küsime kasutajalt nime, mida ta soovib süsteemi lisada
    echo -n "Sisesta kasutajanimi (või 'X', et lõpetada): "
    read username

    # Kui sisestatakse "X" või "x", lõpetame skripti töö
    if [[ "$username" == "X" || "$username" == "x" ]]; then
        echo "Lõpetan skripti töö."
        break
    fi

    # Küsime grupi nime, kuhu kasutaja kuulub ("opilased" või "opetajad")
    echo -n "Sisesta kasutaja grupp ('opilased' või 'opetajad'): "
    read group

    # Käivitame kasutaja loomise funktsiooni ja kontrollime, kas kõik oli korrektne
    create_user "$username" "$group"
done
