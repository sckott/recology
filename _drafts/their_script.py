def hello(path, stuff=None):
    return path


def goodbye(path, stuff=None):
    return path


def world():
    path_str = hello(path="src/world.py", stuff="hello mars")
    other_path_str = goodbye(path="src/world.py", stuff="hello saturn")

    return path_str, other_path_str


if __name__ == "__main__":
    print(world())
