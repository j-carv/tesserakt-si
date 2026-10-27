"""Verify the installed package is importable."""


def test_package_is_importable():
    import tesserakt

    assert tesserakt.__name__ == "tesserakt"
