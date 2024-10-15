#!/bin/bash

# Kontrollime, kas apache2 on juba paigaldatud, kasutades dpkg-query käsku.
# See käsk kontrollib paketi olekut ja kuvab "Status" välja. Kui pakett on paigaldatud,
# peaks väljund sisaldama "ok installed". Kui apache2 ei ole paigaldatud, läheb else haru käiku.
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"; then
    # Kui apache2 on paigaldatud, teavitatakse kasutajat ja käivitatakse teenuse oleku kontroll.
    echo "Apache2 on juba paigaldatud."
    # Kuvame apache2 teenuse staatuse, kasutades systemctl status käsku.
    systemctl status apache2
else
    # Kui apache2 ei ole paigaldatud, anname sellest kasutajale teada ja alustame paigaldamist.
    echo "Apache2 ei ole paigaldatud. Paigaldame nüüd..."
    
    # Enne uue tarkvara paigaldamist uuendame pakettide nimekirja.
    sudo apt-get update
    
    # Paigaldame apache2 veebiserveri koos kõigi vajalike sõltuvustega.
    sudo apt-get install -y apache2
    
    # Kui paigaldamine on edukalt lõpule viidud, teavitame kasutajat.
    echo "Apache2 on nüüd paigaldatud."
    
    # Pärast paigaldamist käivitame apache2 teenuse ja kuvame selle staatuse.
    sudo systemctl start apache2
    
    # Kuvame uuesti apache2 teenuse staatuse, veendumaks, et see töötab korrektselt.
    sudo systemctl status apache2
fi
