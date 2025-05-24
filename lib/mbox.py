import tkinter as tk
from tkinter import filedialog
import mailbox
import pandas as pd
from email import policy
from email.parser import BytesParser

# Hide the main tkinter window
root = tk.Tk()
root.withdraw()

# Prompt to select the MBOX file
mbox_file = filedialog.askopenfilename(
    title="Select MBOX file",
    filetypes=[("MBOX files", "*.mbox"), ("All files", "*.*")]
)
if not mbox_file:
    print("No MBOX file selected. Exiting.")
    exit()

# Prompt to choose where to save the Excel file
output_file = filedialog.asksaveasfilename(
    title="Save Excel as...",
    defaultextension=".xlsx",
    filetypes=[("Excel files", "*.xlsx"), ("All files", "*.*")]
)
if not output_file:
    print("No output file selected. Exiting.")
    exit()

# Open the MBOX mailbox
mbox = mailbox.mbox(
    mbox_file,
    factory=lambda f: BytesParser(policy=policy.default).parse(f)
)

# Parse messages into a list of dicts
emails = []
for msg in mbox:
    date      = msg.get('Date', '')
    sender    = msg.get('From', '')
    recipient = msg.get('To', '')
    subject   = msg.get('Subject', '')
    print(f"Processing message: {subject} from {sender}")

    # Extract plain-text body and decode bytes -> str
    body = ''
    if msg.is_multipart():
        for part in msg.walk():
            if part.get_content_type() == 'text/plain' and not part.get('Content-Disposition'):
                payload = part.get_payload(decode=True)  # this returns bytes
                charset = part.get_content_charset() or 'utf-8'
                body = payload.decode(charset, errors='replace')
                break
    else:
        payload = msg.get_payload(decode=True)
        # If decode=True returned None, fallback to get_content()
        if payload is None:
            body = msg.get_content()
        else:
            charset = msg.get_content_charset() or 'utf-8'
            body = payload.decode(charset, errors='replace')

    # Now it's a str, so strip & replace will work
    body = body.strip().replace('\n', ' ')

    emails.append({
        'Date':    date,
        'From':    sender,
        'To':      recipient,
        'Subject': subject,
        'Body':    body
    })

# Convert to DataFrame and save as before
df = pd.DataFrame(emails)
df.to_excel(output_file, index=False)
print(f"Saved {len(df)} messages to {output_file}")