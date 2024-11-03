#!/bin/bash
# Skript lisab kasutajad ja määrab paroolid kahest failist: üks kasutajate jaoks, teine paroolide jaoks.
# Skript kontrollib, kas kasutaja on juba süsteemis olemas, ning teatab sellest, kui on.
# Kasutamine: ./kasutajad_eraldatud.sh <kasutajate_fail> <paroolide_fail>

# Kontrollime, kas skripti käivitati root õigustes
if [ "$(id -u)" -ne 0 ]; then
    echo "Seda skripti peab käivitama root õigustes!"
    exit 1
fi

# Kontrollime, kas on antud kaks failinime
if [ $# -ne 2 ]; then
    echo "Kasutusjuhend: $0 <kasutajate_fail> <paroolide_fail>"
    exit 1
fi

# Määrame muutujad failide jaoks
kasutajad_fail="$1"
paroolid_fail="$2"

# Kontrollime, kas failid eksisteerivad ja on loetavad
if [ ! -f "$kasutajad_fail" ] || [ ! -f "$paroolid_fail" ]; then
    echo "Viga: üks või mõlemad failid puuduvad."
    exit 2
fi

if [ ! -r "$kasutajad_fail" ] || [ ! -r "$paroolid_fail" ]; then
    echo "Viga: üks või mõlemad failid pole loetavad."
    exit 2
fi

# Kontrollime, kas failides on sama arv ridu
kasutajad_read=$(wc -l < "$kasutajad_fail")
paroolid_read=$(wc -l < "$paroolid_fail")

if [ "$kasutajad_read" -ne "$paroolid_read" ]; then
    echo "Viga: failides pole sama arv ridu!"
    echo "Kasutajate failis: $kasutajad_read rida(de)"
    echo "Paroolide failis: $paroolid_read rida(de)"
    exit 3
fi

# Loeme kasutajad ja paroolid failidest
while IFS= read -r kasutajanimi <&3 && IFS= read -r parool <&4; do
    # Eemaldame võimalikud tühikud ja tabulaatorid
    kasutajanimi=$(echo "$kasutajanimi" | tr -d ' \t')
    parool=$(echo "$parool" | tr -d ' \t')

    # Kontrollime, kas rida sisaldab kasutajanime ja parooli
    if [ -n "$kasutajanimi" ] && [ -n "$parool" ]; then
        # Kontrollime, kas kasutaja juba eksisteerib süsteemis
        if id "$kasutajanimi" &>/dev/null; then
            echo "Kasutaja '$kasutajanimi' on juba süsteemis olemas. Jätame vahele."
            continue
        fi

        # Lisame kasutaja süsteemi koos kodukataloogi ja Bash shelliga
        if useradd -m -s /bin/bash "$kasutajanimi"; then
            echo "Kasutaja '$kasutajanimi' on edukalt lisatud süsteemi."
            
            # Määrame parooli kasutajale
            if echo "$kasutajanimi:$parool" | chpasswd; then
                echo "Parool on edukalt määratud kasutajale '$kasutajanimi'."
                
                # Kuvame info loodud kasutajast
                echo "Kasutaja info:"
                grep "^$kasutajanimi:" /etc/passwd
                echo "Kodukataloog:"
                ls -la "/home/$kasutajanimi"
            else
                echo "Viga: parooli määramine kasutajale '$kasutajanimi' ebaõnnestus."
            fi
        else
            echo "Viga: kasutaja '$kasutajanimi' lisamine ebaõnnestus."
        fi
    else
        echo "Viga: tühi rida või vigane formaat real."
    fi
done 3<"$kasutajad_fail" 4<"$paroolid_fail"

echo "Skripti töö on lõppenud."
