# TCGplayer to USPS Label Converter

Automatically converts TCGplayer shipping exports to USPS-compatible label format.


## Security Note

**IMPORTANT:** If you share your program files with others, be aware that `config.json` contains your personal information (name, address, etc.). The file is already in `.gitignore` to protect against accidental GitHub commits, but always verify you're not including it when sharing files directly.

## Setup

### Quick Setup (Recommended)
1. **Double-click `Setup.bat`**
2. Follow the prompts to enter your information
3. Done!

### Manual Setup

1. **Copy the config file:**
   ```
   Copy config.example.json to config.json
   ```

2. **Edit config.json with your information:**
   - Update your TCGplayer credentials (for future auto-download feature)
   - Verify your sender information
   - Adjust package defaults if needed

3. **Important:** Never commit `config.json` to GitHub! It's already in `.gitignore`.

## Usage

### Easy Way (Double-click)
Simply double-click **Convert TCGplayer to USPS.bat**

### Manual Way
```powershell
.\ConvertToUSPS.ps1
```

## What It Does

1. Finds the newest TCGplayer export in your Downloads folder
2. Converts it to USPS Label Template format
3. Saves the output to `Output/USPS_Labels_Xorders_MmmDD.csv`
4. Archives the original TCGplayer file to `TCGplayer_Archive/`
5. Deletes the original from Downloads

## Folder Structure

```
USPS_Label_Converter/
â”œâ”€â”€ ConvertToUSPS.ps1          # Main conversion script
â”œâ”€â”€ Convert TCGplayer to USPS.bat  # Click-to-run
â”œâ”€â”€ config.json                # Your secrets (DO NOT commit!)
â”œâ”€â”€ config.example.json        # Template for GitHub
â”œâ”€â”€ .gitignore                 # Protects your secrets
â”œâ”€â”€ Output/                    # Converted USPS labels
â””â”€â”€ TCGplayer_Archive/         # Archived TCGplayer exports
```

## Future Features

- Automatic download from TCGplayer website (work in progress)


