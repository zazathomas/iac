import json
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))

from discover import redact  # noqa: E402
from render_flat import render  # noqa: E402


class DiscoveryAndRenderTests(unittest.TestCase):
    def test_redact_removes_sensitive_keys_recursively(self):
        value = {
            "clientId": "example",
            "clientSecret": "do-not-persist",
            "nested": {
                "password": "do-not-persist",
                "accessToken": "do-not-persist",
            },
        }

        result = redact(value)

        self.assertEqual(result["clientId"], "example")
        self.assertNotIn("clientSecret", result)
        self.assertNotIn("password", result["nested"])
        self.assertNotIn("accessToken", result["nested"])

    def test_renderer_is_deterministic_and_does_not_render_secrets(self):
        inventory = {
            "clients": [
                {
                    "id": "client-1",
                    "clientId": "example",
                    "protocol": "openid-connect",
                    "enabled": True,
                    "publicClient": False,
                    "bearerOnly": False,
                    "standardFlowEnabled": True,
                    "redirectUris": ["https://example.test/callback"],
                    "webOrigins": ["https://example.test"],
                }
            ],
            "client_scopes": [],
            "realm_roles": [],
            "groups": [],
            "group_role_mappings": {},
            "client_protocol_mappers": {"client-1": []},
            "scope_protocol_mappers": {},
        }

        first, first_imports = render(inventory, {}, "homelab", "homelab")
        second, second_imports = render(inventory, {}, "homelab", "homelab")

        self.assertEqual(first, second)
        self.assertEqual(first_imports, second_imports)
        self.assertNotIn("client_secret", json.dumps(first))
        self.assertIn('module "homelab_example_client"', first["clients.tf"])


if __name__ == "__main__":
    unittest.main()
