package setup;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;

using StringTools;

class SetupHXCPP
{
    static function main() {
		var path:String = new Process('haxelib', ['libpath', 'hxcpp']).stdout.readLine();

		if (path.toLowerCase().startsWith("error") || !FileSystem.exists(path)) {
			Sys.stderr().writeString('Couldn\'t find the library "hxcpp" while targetting C++! Is it installed?');
            Sys.exit(1);
		}

		var hxcppN:String = Path.join([path, "hxcpp.n"]);

		if (FileSystem.exists(hxcppN)) {
			// hxcpp build tools were already set up
			return;
		}

		var toolsPath:String = Path.join([path, "tools/hxcpp"]);
		var oldDirectory:String = Sys.getCwd();
		Sys.setCwd(toolsPath);

		var process = new Process('haxe', ['compile.hxml']);

		if (process.exitCode() != 0)
			trace("Couldn't compile HXCPP Tools. Is HXCPP installed properly?");

		process.close();

		Sys.setCwd(oldDirectory);
    }
}