# manikandanashok2002@gmail.com
# dszj pzxe bjxf aqyu


#!/bin/bash

# Function to send mail with attachments
send_mail() {
    # Set email parameters
    TO="manikandanashok2002@gmail.com"
    SUBJECT="Security Alert Detected"
    BODY="Person without ID Card and shoes detected. Please find the attached images for reference."

    # Define an array containing paths to each image
    IMAGE_PATHS=(
        "./runs/detect/exp/crops/No_ID_Card/05.jpg"
        "C:\\Final your project\\Source code\\Source code\\yolo\\runs\\detect\\exp\\crops\\No_Shoes\\05.jpg"
        # "C:\\Final your project\\Source code\\Source code\\yolo\\runs\\detect\\exp\\crops\\No_Shoes\\010.jpg"
    )

    # Prepare attachment string
    ATTACHMENTS=""
    for IMAGE_PATH in "${IMAGE_PATHS[@]}"; do
        ATTACHMENTS+="\"$IMAGE_PATH\","
    done
    ATTACHMENTS=${ATTACHMENTS%,}  # Remove the trailing comma

    # Send email using PowerShell with attachments
    powershell.exe -Command "Send-MailMessage -SmtpServer smtp.gmail.com -Port 587 -UseSsl -From manikandanashok2002@gmail.com -To $TO -Subject '$SUBJECT' -Body '$BODY' -Attachments $ATTACHMENTS -Credential (Get-Credential)"
}

# Remove any existing detected results
cd yolo && rm -rf ./runs/detect

# Run the traffic-monitor.py script with webcam as the source in the background
python detect.py --source 0 --weights 'id1.pt' --save-crop &

# Wait for user input to stop the webcam (press 'q' and Enter to quit)
echo "Press 'q' and Enter to stop the webcam..."
read -r STOP_SIGNAL

# Terminate the traffic-monitor.py script when 'q' is pressed
if [ "$STOP_SIGNAL" == "q" ]; then
    pkill -f "python detect.py --source 0 --weights"
fi

# Send mail with attachments after traffic detection
send_mail
