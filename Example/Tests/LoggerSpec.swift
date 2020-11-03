//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

import Quick
import Nimble
import InjectableLoggers

class LoggerSpec: QuickSpec {
    
    override func spec() {
        describe("Logger") {
            
            var sut: Logger!
            var settings: Logger.Settings!
            var mockDestination: MockLogger!
            
            beforeEach {
                mockDestination = MockLogger()
                settings = Logger.Settings()
                settings.destination = mockDestination
            }
            
            context("default lineNumber", closure: {
                beforeEach {
                    settings.activeLogLevel = .verbose
                    settings.defaultLogLevel = .verbose
                    settings.loglevelStrings = [.verbose: "🎉"]
                    settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true)]
                    sut = Logger(settings: settings)
                }
                
                it("logs to destination", closure: {
                    sut.log()
                    sut.log("message")
                    sut.log("message", atLevel: Loglevel.verbose)
                    
                    expect(mockDestination.loggedMessages.count).to(equal(3))
                    expect(mockDestination.loggedMessages[0].message as? String).to(equal("🎉 LoggerSpec.spec() 30"))
                    expect(mockDestination.loggedMessages[1].message as? String).to(equal("🎉 LoggerSpec.spec() 31 message"))
                    expect(mockDestination.loggedMessages[2].message as? String).to(equal("🎉 LoggerSpec.spec() 32 message"))
                })
            })
            
            context("empty loglevelStrings", closure: {
                beforeEach {
                    settings.activeLogLevel = .verbose
                    settings.defaultLogLevel = .verbose
                    settings.loglevelStrings = [.verbose: "🎉"]
                    settings.formatSettings = [Loglevel: Logger.FormatSettings]()
                    sut = Logger(settings: settings)
                }
                
                it("logs to destination", closure: {
                    sut.log(atLine: 42)
                    sut.log("message", atLine: 42)
                    sut.log("message", atLevel: Loglevel.verbose, atLine: 42)
                    
                    expect(mockDestination.loggedMessages.count).to(equal(3))
                    expect(mockDestination.loggedMessages[0].message as? String).to(equal(""))
                    expect(mockDestination.loggedMessages[1].message as? String).to(equal("message"))
                    expect(mockDestination.loggedMessages[2].message as? String).to(equal("message"))
                })
            })
            
            context("empty formatterSettings", closure: {
                beforeEach {
                    settings.activeLogLevel = .verbose
                    settings.defaultLogLevel = .verbose
                    settings.loglevelStrings = [Loglevel: String]()
                    settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true)]
                    sut = Logger(settings: settings)
                }
                
                it("logs to destination", closure: {
                    sut.log(atLine: 42)
                    sut.log("message", atLine: 42)
                    sut.log("message", atLevel: Loglevel.verbose, atLine: 42)
                    
                    expect(mockDestination.loggedMessages.count).to(equal(3))
                    expect(mockDestination.loggedMessages[0].message as? String).to(equal("LoggerSpec.spec() 42"))
                    expect(mockDestination.loggedMessages[1].message as? String).to(equal("LoggerSpec.spec() 42 message"))
                    expect(mockDestination.loggedMessages[2].message as? String).to(equal("LoggerSpec.spec() 42 message"))
                })
            })
            
            context("relay", closure: {
                let mockRelay = MockLogger()
                
                beforeEach {
                    settings.activeLogLevel = .inactive
                    settings.defaultLogLevel = .inactive
                    sut = Logger(settings: settings)
                    sut.relay = mockRelay
                }
                
                it("logs everyting to relay", closure: {
                    sut.log("aaa", atLevel: .verbose, inFile: "bbb", inFunction: "ccc", atLine: 42)
                    sut.log("ddd", atLevel: .inactive, inFile: "eee", inFunction: "fff", atLine: 22)
                    
                    expect(mockRelay.loggedMessages.count).to(equal(2))
                    
                    let loggedMessage0 = mockRelay.loggedMessages[0]
                    expect(loggedMessage0.message as? String).to(equal("aaa"))
                    expect(loggedMessage0.level).to(equal(.verbose))
                    expect(loggedMessage0.file).to(equal("bbb"))
                    expect(loggedMessage0.function).to(equal("ccc"))
                    expect(loggedMessage0.line).to(equal(42))
                    
                    let loggedMessage1 = mockRelay.loggedMessages[1]
                    expect(loggedMessage1.message as? String).to(equal("ddd"))
                    expect(loggedMessage1.level).to(equal(.inactive))
                    expect(loggedMessage1.file).to(equal("eee"))
                    expect(loggedMessage1.function).to(equal("fff"))
                    expect(loggedMessage1.line).to(equal(22))
                })
            })
            
            context("When initializing with settings that contains a relay", {
                
                beforeEach {
                    settings.relay = Logger()
                    sut = Logger(settings: settings)
                }
                
                it("Then it's relay is the relay from settings", closure: {
                    expect(sut.relay).to(beIdenticalTo(settings.relay))
                })
            })
            
            context("verbose active loglevel", {
                beforeEach {
                    settings.activeLogLevel = .verbose
                }
                
                //MARK: non empty loglevelStrings
                context("non empty loglevelStrings", closure: {
                    beforeEach {
                        settings.loglevelStrings = [.verbose: "🔍", .info: "ℹ️", .warning: "⚠️", .error:"⛔️"]
                    }
                    
                    //MARK: formatter settings A
                    context("formatter settings A", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log(atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message", atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log(atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message", atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose, atLine: 42)
                                    sut.log(atLevel: Loglevel.warning, atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec.spec() 42"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose, atLine: 42)
                                    sut.log("message", atLevel: Loglevel.warning, atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec.spec() 42 message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings B
                    context("formatter settings B", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec.spec() message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec.spec() message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec.spec()"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec.spec() message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec.spec() message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings C
                    context("formatter settings C", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 LoggerSpec message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ LoggerSpec message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 LoggerSpec message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ LoggerSpec message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings D
                    context("formatter settings D", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("🔍 message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️ message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("🔍 message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️ message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings E
                    context("formatter settings E", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal(""))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings F
                    context("formatter settings F", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: true, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: true, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: true, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: true, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec() message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec() message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("spec()"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec()"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("spec() message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("spec() message"))
                                })
                            })
                        })
                    })
                })
                
                //MARK: empty loglevelStrings
                context("empty loglevelStrings", closure: {
                    beforeEach {
                        settings.loglevelStrings = [.verbose: "", .info: "", .warning: "", .error:""]
                    }
                    
                    //MARK: formatter settings A
                    context("formatter settings A", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log(atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message", atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log(atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message", atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose, atLine: 42)
                                    sut.log(atLevel: Loglevel.warning, atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec.spec() 42"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose, atLine: 42)
                                    sut.log("message", atLevel: Loglevel.warning, atLine: 42)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec.spec() 42 message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() 42 message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings B
                    context("formatter settings B", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec.spec()"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec()"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec.spec() message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec.spec() message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings C
                    context("formatter settings C", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec"))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec"))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("LoggerSpec message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("LoggerSpec message"))
                                })
                            })
                        })
                    })
                    
                    //MARK: formatter settings D
                    context("formatter settings D", {
                        beforeEach {
                            settings.formatSettings = [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                       .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)]
                        }
                        
                        context("verbose default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .verbose
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                        
                        context("info default loglevel", {
                            beforeEach {
                                settings.defaultLogLevel = .info
                                sut = Logger(settings: settings)
                            }
                            
                            context("log", {
                                it("logs to destination", closure: {
                                    sut.log()
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message", {
                                it("logs to destination", closure: {
                                    sut.log("message")
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(1))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                        
                        context("independent of default loglevel", closure: {
                            beforeEach {
                                sut = Logger(settings: settings)
                            }
                            
                            context("log at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log(atLevel: Loglevel.verbose)
                                    sut.log(atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal(""))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal(""))
                                })
                            })
                            
                            context("log message at level", closure: {
                                it("logs to destination", closure: {
                                    sut.log("message", atLevel: Loglevel.verbose)
                                    sut.log("message", atLevel: Loglevel.warning)
                                    
                                    expect(mockDestination.loggedMessages.count).to(equal(2))
                                    expect(mockDestination.loggedMessages.first?.message as? String).to(equal("message"))
                                    expect(mockDestination.loggedMessages.last?.message as? String).to(equal("message"))
                                })
                            })
                        })
                    })
                })
            })
            
            context("other active loglevels", closure: {
                
                beforeEach {
                    settings.loglevelStrings = [.verbose: "🔍", .info: "ℹ️", .warning: "⚠️", .error:"⛔️", .inactive: "🔥"]
                    settings.formatSettings = [ Loglevel.verbose: Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                Loglevel.info: Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                Loglevel.warning: Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                Loglevel.error: Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                Loglevel.inactive: Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)]
                    settings.activeLogLevel = .info
                    
                }
                
                context("info level", closure: {
                    beforeEach {
                        settings.activeLogLevel = .info
                        settings.destination = mockDestination
                        sut = Logger(settings: settings)
                    }
                    
                    it("logs to destination when needed", closure: {
                        sut.log(atLevel: .verbose)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .info)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("ℹ️"))
                        
                        sut.log(atLevel: .warning)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️"))
                        
                        sut.log(atLevel: .error)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        sut.log(atLevel: .inactive)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        expect(mockDestination.loggedMessages.count).to(equal(3))
                    })
                })
                
                context("warning level", closure: {
                    beforeEach {
                        settings.activeLogLevel = .warning
                        settings.destination = mockDestination
                        sut = Logger(settings: settings)
                    }
                    
                    it("logs to destination when needed", closure: {
                        sut.log(atLevel: .verbose)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .info)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .warning)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⚠️"))
                        
                        sut.log(atLevel: .error)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        sut.log(atLevel: .inactive)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        expect(mockDestination.loggedMessages.count).to(equal(2))
                    })
                })
                
                context("error level", closure: {
                    beforeEach {
                        settings.activeLogLevel = .error
                        settings.destination = mockDestination
                        sut = Logger(settings: settings)
                    }
                    
                    it("logs to destination when needed", closure: {
                        sut.log(atLevel: .verbose)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .info)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .warning)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .error)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        sut.log(atLevel: .inactive)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(equal("⛔️"))
                        
                        expect(mockDestination.loggedMessages.count).to(equal(1))
                    })
                })
                
                context("inactive level", closure: {
                    beforeEach {
                        settings.activeLogLevel = .inactive
                        settings.destination = mockDestination
                        sut = Logger(settings: settings)
                    }
                    
                    it("logs to destination when needed", closure: {
                        sut.log(atLevel: .verbose)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .info)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .warning)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .error)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        sut.log(atLevel: .inactive)
                        expect(mockDestination.loggedMessages.last?.message as? String).to(beNil())
                        
                        expect(mockDestination.loggedMessages.count).to(equal(0))
                    })
                })
            })
        }
    }
}
