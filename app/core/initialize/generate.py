# app/core/initialize/generate.py

from importlib.resources import files
from pathlib import Path

from app.constants.path import (
    TARGET_PROJECT_SOURCE,
)


class ScaffoldGenerator:
    def __init__(self, force=False, interactive=False):
        self.force = force
        self.interactive = interactive

    def create_directories(self, dirs):
        for d in dirs:
            Path(d).mkdir(parents=True, exist_ok=True)

    def should_write(self, path: Path):
        if not path.exists():
            return True

        if self.force:
            return True

        if self.interactive:
            ans = input(f"{path} exists. Overwrite? (y/N): ")
            return ans.lower() == "y"

        return False

    def write_file(self, template):
        path = Path(template.target_path)

        if not self.should_write(path):
            print(f"⏭️ Skipped: {path}")
            return

        path.parent.mkdir(parents=True, exist_ok=True)

        content = template.render()

        path.write_text(content, encoding="utf-8")
        print(f"✅ Created: {path}")

    def copy_package_dir(self, package_path: str, target_path: str, force=False):
        src_root = files(f"{TARGET_PROJECT_SOURCE}.templates").joinpath(package_path)
        dst_root = Path(target_path)

        for item in src_root.rglob("*"):
            relative = item.relative_to(src_root)
            target = dst_root / relative

            if item.is_dir():
                target.mkdir(parents=True, exist_ok=True)
            else:
                if target.exists() and not force:
                    continue

                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(item.read_text(encoding="utf-8"), encoding="utf-8")

                print(f"📄 Copied: {target}")

    def run(
        self,
        templates=None,
        dirs=None,
        template_dirs=None,
    ):
        if dirs:
            self.create_directories(dirs)

        if templates:
            for t in templates:
                self.write_file(t)

        if template_dirs:
            for d in template_dirs:
                self.copy_package_dir(d.source, d.target, force=self.force)
