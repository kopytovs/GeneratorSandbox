
public protocol SecondSampleProtocol: AnyObject {
    var getOnlyProperty: String { get }
    func argsNoResult(arg1: Int, arg2: String)
    func argsAndResult(arg1: Int, arg2: String) -> String
}
