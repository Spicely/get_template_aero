import os

ROOT_DIR = '/Users/spicely/Desktop/www/get_template_aero/aero_template_reference'
REPLACEMENTS = {
    '{{project_name.snakeCase()}}': 'aero_template_reference',
    '{{description_info}}': 'A reference implementation for the Aero template.'
}

def normalize_project():
    print(f"Normalizing project in {ROOT_DIR}")
    
    # 1. Rename files/directories
    for root, dirs, files in os.walk(ROOT_DIR, topdown=False):
        for name in dirs + files:
            new_name = name
            for key, val in REPLACEMENTS.items():
                if key in new_name:
                    new_name = new_name.replace(key, val)
            
            if new_name != name:
                old_path = os.path.join(root, name)
                new_path = os.path.join(root, new_name)
                print(f"Renaming {old_path} -> {new_path}")
                os.rename(old_path, new_path)

    # 2. Replace content
    for root, dirs, files in os.walk(ROOT_DIR):
        for name in files:
            # Skip hidden files and binary extensions
            if name.startswith('.'): continue
            if name.endswith(('.png', '.jpg', '.jpeg', '.lock', '.webp', '.ico', '.so', '.dll')): continue
            
            path = os.path.join(root, name)
            try:
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = content
                for key, val in REPLACEMENTS.items():
                    new_content = new_content.replace(key, val)
                
                if new_content != content:
                    print(f"Updating content in {path}")
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
            except UnicodeDecodeError:
                print(f"Skipping binary file {path}")
            except Exception as e:
                print(f"Error processing {path}: {e}")

if __name__ == '__main__':
    normalize_project()
